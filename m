Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab0DAPjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:39:06 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49247 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab0DAPi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:38:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=HXM2dB3PdYtq3829P+rfEjTcd+JRZp7FpY4zqsdJrtlp1qbv26enxfBmVZzOfziqEj
         yK5MN9PDpbh072AjqQQWav3mgUx2QC4jRm4s6egIQZWOxJ3rW1798hiDgNV8udyMpUEv
         LmbTR3Stnq2fx/mSoEHXWjazm7tqa+eQ6stfU=
Date: Thu, 1 Apr 2010 18:38:40 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: [PATCH 1/1] infiniband: ulp/iser, fix error retval in
	iser_create_ib_conn_res
Message-ID: <20100401153839.GA5265@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Roland Dreier <rdreier@cisco.com>, Jiri Slaby <jslaby@suse.cz>,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Or Gerlitz <ogerlitz@voltaire.com>
References: <1268750962-13547-1-git-send-email-jslaby@suse.cz> <ada634v9644.fsf@roland-alpha.cisco.com> <20100317151122.GF5331@bicker> <adak4ssi4ky.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adak4ssi4ky.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 02:06:21PM -0700, Roland Dreier wrote:
> So looking at merging this finally, I think I see one problem with the
> proposed patch.  We have:
> 
>  > @@ -183,7 +180,7 @@  static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
>  >  	ib_conn->fmr_pool = ib_create_fmr_pool(device->pd, &params);
>  >  	if (IS_ERR(ib_conn->fmr_pool)) {
>  >  		ret = PTR_ERR(ib_conn->fmr_pool);
>  > -		goto fmr_pool_err;
>  > +		goto out_err;
>  >  	}
> 
> and
> 
>  > @@ -209,12 +206,7 @@  static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
>  >  		 ib_conn->fmr_pool, ib_conn->cma_id->qp);
>  >  	return ret;
>  >  
>  > -qp_err:
>  > -	(void)ib_destroy_fmr_pool(ib_conn->fmr_pool);
>  > -fmr_pool_err:
>  > -	kfree(ib_conn->page_vec);
>  > -	kfree(ib_conn->login_buf);
>  > -alloc_err:
>  > +out_err:
>  >  	iser_err("unable to alloc mem or create resource, err %d\n", ret);
>  >  	return ret;
>  >  }
> 
> so if ib_create_fmr_pool() fails, we're left with ib_conn->fmr_pool
> holding an error pointer, right?  But we're relying on
> iser_free_ib_conn_res() to clean up after us, and that has:
> 
> 	if (ib_conn->fmr_pool != NULL)
> 		ib_destroy_fmr_pool(ib_conn->fmr_pool);
> 
> so we're going to end up trying to free an error pointer, which will
> probably crash.
> 
> I think.
> 
> Dan or Or, am I wrong here or do we need another iteration of this
> patch? (the login_buf and page_vec changes do look correct to me, since
> a failed kmalloc() will leave us with a NULL pointer that it is safe to
> kfree() later)

You're right.  I missed that.

I will send an updated patch tomorrow.

regards,
dan carpenter

> 
>  - R.
> -- 
> Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
> http://www.cisco.com/web/about/doing_business/legal/cri/index.html
