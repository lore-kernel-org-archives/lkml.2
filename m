Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2ISPxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:53:16 -0400
Received: from mx2.netapp.com ([216.240.18.37]:10513 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab2ISPxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:53:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="691563905"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Adamson, Dros" <Weston.Adamson@netapp.com>
Subject: Re: [ 117/135] NFS: return error from decode_getfh in decode open
Thread-Topic: [ 117/135] NFS: return error from decode_getfh in decode open
Thread-Index: AQHNlG5bpNNqrC6kfkK0fAyUiTIHlpeRWAuAgAAlMQCAAMz7gA==
Date: Wed, 19 Sep 2012 15:53:10 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908FD7C84@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120917003625.784119135@decadent.org.uk>
	 <20120917003642.413673073@decadent.org.uk>
	 <20120919012623.GA17910@herton-Z68MA-D2H-B3>
	 <1348025970.4836.38.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1348025970.4836.38.camel@deadeye.wl.decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C2A368F5FCBBB45BC52C500634FC1B3@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q8JFrTq8031251

On Wed, 2012-09-19 at 04:39 +0100, Ben Hutchings wrote:
> On Tue, 2012-09-18 at 22:26 -0300, Herton Ronaldo Krzesinski wrote:
> > On Mon, Sep 17, 2012 at 01:38:22AM +0100, Ben Hutchings wrote:
> > > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > I'm not sure whether my expansion of the fix is correct here.
> > > 
> > > ------------------
> > > 
> > > From: Weston Andros Adamson <dros@netapp.com>
> > > 
> > > commit 01913b49cf1dc6409a07dd2a4cc6af2e77f3c410 upstream.
> > > 
> > > If decode_getfh failed, nfs4_xdr_dec_open would return 0 since the last
> > > decode_* call must have succeeded.
> > > 
> > > Signed-off-by: Weston Andros Adamson <dros@netapp.com>
> > > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > > [bwh: Backported to 3.2: this function makes two more function calls
> > >  (no longer present in mainline) with the same issue, so fix them up
> > >  similarly.]
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > > ---
> > >  fs/nfs/nfs4xdr.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > --- a/fs/nfs/nfs4xdr.c
> > > +++ b/fs/nfs/nfs4xdr.c
> > > @@ -6113,12 +6113,15 @@ static int nfs4_xdr_dec_open(struct rpc_
> > >  	status = decode_open(xdr, res);
> > >  	if (status)
> > >  		goto out;
> > > -	if (decode_getfh(xdr, &res->fh) != 0)
> > > +	status = decode_getfh(xdr, &res->fh);
> > > +	if (status)
> > >  		goto out;
> > > -	if (decode_getfattr(xdr, res->f_attr, res->server,
> > > -				!RPC_IS_ASYNC(rqstp->rq_task)) != 0)
> > > +	status = decode_getfattr(xdr, res->f_attr, res->server,
> > > +				 !RPC_IS_ASYNC(rqstp->rq_task));
> > 
> > I'm also not sure about the expansion of the fix here, not knowing very
> > much about nfs. It seems that the code in some cases want to discard the
> > status from decode_getfattr, for example nfs4_xdr_dec_rename is one case
> > which does the same. Is it ok to return the status of decode_getfattr on
> > nfs4_xdr_dec_open here? Or should it remain like it was before?
> 
> It looks like we try to get the file and directory attributes, and those
> are nice to have but the open operation is still successful even if we
> can't get them.  So my extra 'fixes' here are wrong.  Trond, is this
> right?

Hi Ben,

We do not want to fail the RPC call in the case where the attribute
decode failed; we already have ways to recover from that situation in
the higher layers of the open code (we send a separate getattr RPC
call). If, on the other hand, the filehandle decode fails, then we are
screwed since we can't know exactly which file was just opened and this
would be the reason for Dros's patch.

So please do leave the decode_getfattr() line as it was, and apply the
change to the decode_getfh() line only.

Cheers
  Trond


> Ben.
> 
> > > +	if (status)
> > >  		goto out;
> > > -	if (decode_restorefh(xdr) != 0)
> > > +	status = decode_restorefh(xdr);
> > > +	if (status)
> > >  		goto out;
> > >  	decode_getfattr(xdr, res->dir_attr, res->server,
> > >  			!RPC_IS_ASYNC(rqstp->rq_task));
> > 
> 

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
