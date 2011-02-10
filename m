Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab1BJR0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:26:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:33514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528Ab1BJR0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:26:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'208";a="706281544"
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos
 before entering idle
From: Tim Chen <tim.c.chen@linux.intel.com>
To: markgross@thegnar.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20110210051042.GC4897@gvim.org>
References: <1297300864.2645.128.camel@schen9-DESK>
	 <20110210051042.GC4897@gvim.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 09:27:24 -0800
Message-ID: <1297358844.2645.140.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 21:10 -0800, mark gross wrote:

> 
> I'm surprised by this as the last update to the pm_qos replaced the
> lists with a O(1) data structure so there was no more walking of pending
> requests.

But you need to acquire a lock before you can read the value on the list
within the function pm_qos_request.  This is a problem if there are a
lot of cpus doing so.

> 
> What is the profile after the patch the Plist should be only one
> dereference and an if instruction slower than a cached value.

After the patch, the acquisition of the lock on plist go away from the
profile, and I see a 12% improvement in throughput to the message
passing benchmark I was running.

> 
> Does your patch remove the need for the locks because if it doesn't I
> don't see how it will make much of a difference?

We still need the lock to update/remove/insert values in the plist and
to update the cached value.  The intention of the patch is to avoid lock
acquisition by reading from a cached value that is up to date. Lock
acquisition is needed --every time-- when a cpu go into idle, which is
bad as you want to let a cpu go to idle ASAP.


Tim

