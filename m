Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1DTXTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:19:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:28611 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab1DTXTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:19:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,248,1301900400"; 
   d="scan'208";a="631752830"
Date: Wed, 20 Apr 2011 16:18:59 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andi Kleen <andi@firstfloor.org>, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SMACK: Add missing rcu_read_lock/unlock for process
 capability walk.
Message-ID: <20110420231859.GB32402@tassilo.jf.intel.com>
References: <1303336844-31074-1-git-send-email-andi@firstfloor.org>
 <4DAF637D.90606@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAF637D.90606@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 03:51:41PM -0700, Casey Schaufler wrote:
> On 4/20/2011 3:00 PM, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > smk_access_entry does a RCU list walk for a list shared with other
> > threads. It relies on the caller doing rcu_read_lock().
> > One caller forgot to do to this, which could lead to races
> > on preemptible kernels.
> >
> > Move the rcu_read_lock() into smk_access_entry instead.
> 
> Nacked-by: Casey Schaufler <casey@schaufler-ca.com>
> 
> The lock was moved out of smk_access_entry in support of the
> processing done in the smack_mmap_file() hook. Where do you see
> a potential race, and which caller "forgot" to do the lock?

There are two callers and only one takes it.
The one that doesn't take it is smk_curacc.

I checked the callers of that and there is no rcu_read_lock() in those

As far as I understand the cred which holds this list is shared
between threads and other threads can modify it. Which means 
it needs RCU read lock protection.

-Andi
