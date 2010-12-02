Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab0LBXzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:55:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757895Ab0LBXzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:55:10 -0500
Date: Thu, 2 Dec 2010 15:54:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Ondrej Zary <linux@rainbow-software.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM / Hibernate: Fix memory corruption related to swap
Message-Id: <20101202155453.92e8ca57.akpm@linux-foundation.org>
In-Reply-To: <201012030040.37273.rjw@sisk.pl>
References: <201012030040.37273.rjw@sisk.pl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010 00:40:36 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> There is a problem that swap pages allocated before the creation of
> a hibernation image can be released and used for storing the contents
> of different memory pages while the image is being saved.  Since the
> kernel stored in the image doesn't know of that, it causes memory
> corruption to occur after resume from hibernation, especially on
> systems with relatively small RAM that need to swap often.
> 
> This issue can be addressed by keeping the GFP_IOFS bits clear
> in gfp_allowed_mask during the entire hibernation, including the
> saving of the image, until the system is finally turned off or
> the hibernation is aborted.  Unfortunately, for this purpose
> it's necessary to rework the way in which the hibernate and
> suspend code manipulates gfp_allowed_mask.
> 
> This change is based on an earlier patch from Hugh Dickins.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Reported-by: Ondrej Zary <linux@rainbow-software.org>
> Acked-by: Hugh Dickins <hughd@google.com>
> ---
> 
> Hi,
> 
> This patch is a fix for a regression and nasty memory corruption, so I'd like
> to push it to Linus for 2.6.37 if there are no objections.
> 

It looks OK to me for 2.6.37 but for 2.6.38 please let's make
everything here a 100% no-op for CONFIG_PM_SLEEP=n builds. 
Specifically the slight overhead in __alloc_pages_nodemask.

Because given the global nature of saved_gfp_mask and the unlocked way
in which it is accessed, this facility won't be at all useful for
anything other than suspend.


