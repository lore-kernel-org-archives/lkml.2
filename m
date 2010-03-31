Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab0CaVG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:06:27 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:44977 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758171Ab0CaVGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:06:25 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKlVs0urR7Ht/2dsb2JhbACbOXGoP5khhQAEgyM
X-IronPort-AV: E=Sophos;i="4.51,343,1267401600"; 
   d="scan'208";a="175546733"
From: Roland Dreier <rdreier@cisco.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: [PATCH 1/1] infiniband: ulp/iser, fix error retval in iser_create_ib_conn_res
References: <1268750962-13547-1-git-send-email-jslaby@suse.cz>
	<ada634v9644.fsf@roland-alpha.cisco.com>
	<20100317151122.GF5331@bicker>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 31 Mar 2010 14:06:21 -0700
In-Reply-To: <20100317151122.GF5331@bicker> (Dan Carpenter's message of "Wed,
	17 Mar 2010 18:11:22 +0300")
Message-ID: <adak4ssi4ky.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So looking at merging this finally, I think I see one problem with the
proposed patch.  We have:

 > @@ -183,7 +180,7 @@  static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 >  	ib_conn->fmr_pool = ib_create_fmr_pool(device->pd, &params);
 >  	if (IS_ERR(ib_conn->fmr_pool)) {
 >  		ret = PTR_ERR(ib_conn->fmr_pool);
 > -		goto fmr_pool_err;
 > +		goto out_err;
 >  	}

and

 > @@ -209,12 +206,7 @@  static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 >  		 ib_conn->fmr_pool, ib_conn->cma_id->qp);
 >  	return ret;
 >  
 > -qp_err:
 > -	(void)ib_destroy_fmr_pool(ib_conn->fmr_pool);
 > -fmr_pool_err:
 > -	kfree(ib_conn->page_vec);
 > -	kfree(ib_conn->login_buf);
 > -alloc_err:
 > +out_err:
 >  	iser_err("unable to alloc mem or create resource, err %d\n", ret);
 >  	return ret;
 >  }

so if ib_create_fmr_pool() fails, we're left with ib_conn->fmr_pool
holding an error pointer, right?  But we're relying on
iser_free_ib_conn_res() to clean up after us, and that has:

	if (ib_conn->fmr_pool != NULL)
		ib_destroy_fmr_pool(ib_conn->fmr_pool);

so we're going to end up trying to free an error pointer, which will
probably crash.

I think.

Dan or Or, am I wrong here or do we need another iteration of this
patch? (the login_buf and page_vec changes do look correct to me, since
a failed kmalloc() will leave us with a NULL pointer that it is safe to
kfree() later)

 - R.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
