Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab1HOKCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:02:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46753 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1HOKCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:02:11 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: mohan@imap.linux.ibm.com
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH] fs/9p: Update zero-copy implementation in 9p
In-Reply-To: <20110815052742.Horde.dzIweZir309OSOaO6aTWOGA@imap.linux.ibm.com>
References: <1312965749-19683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20110815052742.Horde.dzIweZir309OSOaO6aTWOGA@imap.linux.ibm.com>
User-Agent: Notmuch/0.5-318-g52e4ded (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Mon, 15 Aug 2011 15:31:02 +0530
Message-ID: <874o1j0za9.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011 05:27:42 -0400, mohan@imap.linux.ibm.com wrote:
> 
> [snip]
> 
> > + * p9_client_zc_rpc - issue a request and wait for a response
> > + * @c: client session
> > + * @type: type of request
> > + * @uidata: user bffer that should be ued for zero copy read
> > + * @uodata: user buffer that shoud be user for zero copy write
> > + * @inlen: read buffer size
> > + * @olen: write buffer size
> > + * @hdrlen: reader header size, This is the size of response protocol data
> > + * @fmt: protocol format string (see protocol.c)
> > + *
> > + * Returns request structure (which client must free using p9_free_req)
> > + */
> > +static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
> > +					 char *uidata, char *uodata,
> > +					 int inlen, int olen, int in_hdrlen,
> > +					 int kern_buf, const char *fmt, ...)
> 
> Most of the code is duplicated from p9_client_rpc, is it possible to write a
> helper routine which can be used by both p9_client_rpc &
> p9_client_zc_rpc?

I will try that.


> > +{
> > +	va_list ap;
> > +	int tag, err;
> > +	struct p9_req_t *req;
> > +	unsigned long flags;
> > +	int sigpending;
> > +
> > +	P9_DPRINTK(P9_DEBUG_MUX, "client %p op %d\n", c, type);
> > +
> > +	/* we allow for any status other than disconnected */
> > +	if (c->status == Disconnected)
> > +		return ERR_PTR(-EIO);
> > +
> > +	/* If we are called with KERNEL_DS force kern_buf */
> > +	if (segment_eq(get_fs(), KERNEL_DS))
> > +		kern_buf = 1;
> > +
> > +	/* if status is begin_disconnected we allow only clunk request */
> > +	if ((c->status == BeginDisconnect) && (type != P9_TCLUNK))
> > +		return ERR_PTR(-EIO);
> > +
> > +	if (signal_pending(current)) {
> > +		sigpending = 1;
> > +		clear_thread_flag(TIF_SIGPENDING);
> > +	} else
> > +		sigpending = 0;
> > +
> > +	tag = P9_NOTAG;
> > +	if (type != P9_TVERSION) {
> > +		tag = p9_idpool_get(c->tagpool);
> > +		if (tag < 0)
> > +			return ERR_PTR(-ENOMEM);
> > +	}
> > +	/*
> > +	 * We allocate a inline protocol data of only 4k bytes.
> > +	 * The actual content is passed in zero-copy fashion.
> > +	 */
> > +	req = p9_tag_alloc(c, tag, P9_ZC_HDR_SZ);
> > +	if (IS_ERR(req))
> > +		return req;
> > +
> > +	/* marshall the data */
> > +	p9pdu_prepare(req->tc, tag, type);
> > +	va_start(ap, fmt);
> > +	err = p9pdu_vwritef(req->tc, c->proto_version, fmt, ap);
> > +	va_end(ap);
> > +	if (err)
> > +		goto reterr;
> > +	p9pdu_finalize(req->tc);
> > +
> > +	err = c->trans_mod->zc_request(c, req, uidata, uodata,
> > +				       inlen, olen, in_hdrlen, kern_buf);
> > +	if (err < 0) {
> > +		if (err == -EIO)
> > +			c->status = Disconnected;
> > +		goto reterr;
> > +	}
> > +	if (req->status == REQ_STATUS_ERROR) {
> > +		P9_DPRINTK(P9_DEBUG_ERROR, "req_status error %d\n", req->t_err);
> > +		err = req->t_err;
> > +	}
> > +	if ((err == -ERESTARTSYS) && (c->status == Connected)) {
> > +		P9_DPRINTK(P9_DEBUG_MUX, "flushing\n");
> > +		sigpending = 1;
> > +		clear_thread_flag(TIF_SIGPENDING);
> > +
> > +		if (c->trans_mod->cancel(c, req))
> > +			p9_client_flush(c, req);
> > +
> > +		/* if we received the response anyway, don't signal error */
> > +		if (req->status == REQ_STATUS_RCVD)
> > +			err = 0;
> > +	}
> > +	if (sigpending) {
> > +		spin_lock_irqsave(&current->sighand->siglock, flags);
> > +		recalc_sigpending();
> > +		spin_unlock_irqrestore(&current->sighand->siglock, flags);
> > +	}
> > +	if (err < 0)
> > +		goto reterr;
> > +
> > +	err = p9_check_zc_errors(c, req, uidata, in_hdrlen, kern_buf);
> > +	if (!err) {
> > +		P9_DPRINTK(P9_DEBUG_MUX, "exit: client %p op %d\n", c, type);
> > +		return req;
> > +	}
> > +reterr:
> > +	P9_DPRINTK(P9_DEBUG_MUX, "exit: client %p op %d error: %d\n", c, type,
> > +									err);
> > +	p9_free_req(c, req);
> > +	return ERR_PTR(err);
> > +}
> > +
> >  static struct p9_fid *p9_fid_create(struct p9_client *clnt)
> >  {
> >  	int ret;
> > @@ -1329,13 +1512,15 @@ int
> >  p9_client_read(struct p9_fid *fid, char *data, char __user *udata,  
> > u64 offset,
> >  								u32 count)
> >  {
> > -	int err, rsize;
> > -	struct p9_client *clnt;
> > -	struct p9_req_t *req;
> >  	char *dataptr;
> > +	int kernel_buf = 0;
> > +	struct p9_req_t *req;
> > +	struct p9_client *clnt;
> > +	int err, rsize, non_zc = 0;
> > +
> >
> > -	P9_DPRINTK(P9_DEBUG_9P, ">>> TREAD fid %d offset %llu %d\n", fid->fid,
> > -					(long long unsigned) offset, count);
> > +	P9_DPRINTK(P9_DEBUG_9P, ">>> TREAD fid %d offset %llu %d\n",
> > +		   fid->fid, (long long unsigned) offset, count);
> >  	err = 0;
> >  	clnt = fid->clnt;
> >
> > @@ -1346,14 +1531,25 @@ p9_client_read(struct p9_fid *fid, char  
> > *data, char __user *udata, u64 offset,
> >  	if (count < rsize)
> >  		rsize = count;
> >
> > -	/* Don't bother zerocopy for small IO (< 1024) */
> > -	if (((clnt->trans_mod->pref & P9_TRANS_PREF_PAYLOAD_MASK) ==
> > -			P9_TRANS_PREF_PAYLOAD_SEP) && (rsize > 1024)) {
> > -		req = p9_client_rpc(clnt, P9_TREAD, "dqE", fid->fid, offset,
> > -				rsize, data, udata);
> > +	/* Don't bother zerocopy form small IO (< 1024) */
> form Typo?

Yes. Will fix in next update.

> > +	if (clnt->trans_mod->zc_request && rsize > 1024) {
> > +		char *indata;
> > +		if (data) {
> > +			kernel_buf = 1;
> > +			indata = data;
> > +		} else
> > +			indata = (char *)udata;
> > +		/*
> > +		 * response header len is 11
> > +		 * PDU Header(7) + IO Size (4)
> > +		 */
> > +		req = p9_client_zc_rpc(clnt, P9_TREAD, indata, NULL, rsize, 0,
> > +				       11, kernel_buf, "dqd", fid->fid,
> > +				       offset, rsize);
> 

-aneesh
