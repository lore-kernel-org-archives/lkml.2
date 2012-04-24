Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab2DXBgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:36:10 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35169 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2DXBgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:36:08 -0400
Message-ID: <4F960376.6040906@us.ibm.com>
Date: Mon, 23 Apr 2012 18:35:50 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 8/8] PM / Sleep: Add user space interface for manipulating
 wakeup sources
References: <201202070200.55505.rjw@sisk.pl> <201202220031.46219.rjw@sisk.pl> <201204222319.02228.rjw@sisk.pl> <201204222324.45586.rjw@sisk.pl>
In-Reply-To: <201204222324.45586.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042401-7282-0000-0000-0000086D62FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2012 02:24 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki<rjw@sisk.pl>
>
> Android allows user space to manipulate wakelocks using two
> sysfs file located in /sys/power/, wake_lock and wake_unlock.
> Writing a wakelock name and optionally a timeout to the wake_lock
> file causes the wakelock whose name was written to be acquired (it
> is created before is necessary), optionally with the given timeout.
> Writing the name of a wakelock to wake_unlock causes that wakelock
> to be released.
>
> Implement an analogous interface for user space using wakeup sources.
> Add the /sys/power/wake_lock and /sys/power/wake_unlock files
> allowing user space to create, activate and deactivate wakeup
> sources, such that writing a name and optionally a timeout to
> wake_lock causes the wakeup source of that name to be activated,
> optionally with the given timeout.  If that wakeup source doesn't
> exist, it will be created and then activated.  Writing a name to
> wake_unlock causes the wakeup source of that name, if there is one,
> to be deactivated.  Wakeup sources created with the help of
> wake_lock that haven't been used for more than 5 minutes are garbage
> collected and destroyed.  Moreover, there can be only WL_NUMBER_LIMIT
> wakeup sources created with the help of wake_lock present at a time.
>
> The data type used to track wakeup sources created by user space is
> called "struct wakelock" to indicate the origins of this feature.
>
> Signed-off-by: Rafael J. Wysocki<rjw@sisk.pl>
> ---
One small bug.  In wakelock_lookup_add, you're assigning parent after 
you assign node, so at loop exit the parent might be null.
This resulted in some strange cases where I'd add two wakelocks and 
everything would be fine, but then adding the third would cause the 
first two to get lost.

The following patch seems to fix it.

thanks
-john

diff --git a/kernel/power/wakelock.c b/kernel/power/wakelock.c
index 2f99f02..f950cc2 100644
--- a/kernel/power/wakelock.c
+++ b/kernel/power/wakelock.c
@@ -70,6 +70,7 @@ static struct wakelock *wakelock_lookup_add(const char *name, size_t len,
  	while (*node) {
  		int diff;

+		parent = *node;
  		wl = rb_entry(*node, struct wakelock, node);
  		diff = strncmp(name, wl->name, len);
  		if (diff == 0) {
@@ -82,8 +83,6 @@ static struct wakelock *wakelock_lookup_add(const char *name, size_t len,
  			node =&(*node)->rb_left;
  		else
  			node =&(*node)->rb_right;
-
-		parent = *node;
  	}
  	if (!add_if_not_found)
  		return ERR_PTR(-EINVAL);


