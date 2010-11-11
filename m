Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab0KKAjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:39:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:2555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616Ab0KKAjX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:39:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,180,1288594800"; 
   d="scan'208";a="572336743"
From: "Hefty, Sean" <sean.hefty@intel.com>
To: Roland Dreier <rdreier@cisco.com>, Vasiliy Kulikov <segooon@gmail.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Roland Dreier <rolandd@cisco.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Alex Chiang <achiang@hp.com>, Andi Kleen <ak@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Julia Lawall <julia@diku.dk>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 10 Nov 2010 16:39:20 -0800
Subject: RE: [PATCH] infiniband: core: fix information leak to userland
Thread-Topic: [PATCH] infiniband: core: fix information leak to userland
Thread-Index: AcuBM5nWmLc0beQzSEWbJbpgtMiz9AAAuTYA
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B84C5C8D@orsmsx501.amr.corp.intel.com>
References: <1289054481-18145-1-git-send-email-segooon@gmail.com>
 <ada39r8ohiz.fsf@cisco.com>
In-Reply-To: <ada39r8ohiz.fsf@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sean, what is intended for qp_state handling here?  It seems
> ib_copy_qp_attr_to_user() should either clear it or set it to something
> sensible.

I'm not sure what the original intent was, but both libibcm and librdmacm provide the qp_state as input to the init_qp_attr calls.  It doesn't end up mattering if the kernel returns the value because the corresponding call in libibverbs (ibv_copy_qp_attr_from_kern) doesn't copy out the qp_state.  So, the value that was originally specified ends up being used.  The flow looks something like this:

qp_attr.qp_state = INIT;
cmd.qp_state = qp_attr.qp_state;
write(..cmd..);
ibv_copy_qp_attr_from_kern(&qp_attr, cmd.resp)

I agree that it makes sense for ib_copy_qp_attr_to_user() to set the qp_state.  Deciding what to do in libibverbs seems more troublesome.

- Sean
