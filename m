Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab0KKABP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:01:15 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:39496 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab0KKABM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:01:12 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.59,180,1288569600"; 
   d="scan'208";a="379678519"
From: Roland Dreier <rdreier@cisco.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Alex Chiang <achiang@hp.com>, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] infiniband: core: fix information leak to userland
References: <1289054481-18145-1-git-send-email-segooon@gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 10 Nov 2010 16:01:08 -0800
In-Reply-To: <1289054481-18145-1-git-send-email-segooon@gmail.com> (Vasiliy
	Kulikov's message of "Sat, 6 Nov 2010 17:41:20 +0300")
Message-ID: <ada39r8ohiz.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Structure ib_uverbs_qp_attr is copied to userland with allmost all
 > fields uninitialized (140 bytes on x86).  It leads to leaking of
 > contents of kernel stack memory.

I don't think most of the fields are uninitialized... we have:

 	memset(&qp_attr, 0, sizeof qp_attr);

and then later on,

	ib_copy_qp_attr_to_user(&resp, &qp_attr);

which actually does initialize almost all of the fields in resp.  The
things that are missing are clearing out the reserved fields in the
structures, and also resp.qp_state never gets set.

I would suggest adding code to clear the reserved fields of structures
to ib_copy_qp_attr_to_user() and ib_copy_ah_attr_to_user(), since this
will fix what looks to be the same problem in ucma_init_qp_attr() (in
drivers/infiniband/core/ucma.c).

Sean, what is intended for qp_state handling here?  It seems
ib_copy_qp_attr_to_user() should either clear it or set it to something
sensible.

 - R.
