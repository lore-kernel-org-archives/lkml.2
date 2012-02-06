Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2BFG0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 01:26:43 -0500
Received: from 1wt.eu ([62.212.114.60]:62238 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab2BFG0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 01:26:41 -0500
Date: Mon, 6 Feb 2012 07:25:05 +0100
From: Willy Tarreau <w@1wt.eu>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: "gaowanlong@cn.fujitsu.com" <gaowanlong@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        James Bottomley <JBottomley@Parallels.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 32/91] libsas: remove expander from dev list on error
Message-ID: <20120206062505.GG8334@1wt.eu>
References: <20120205220950.812864962@pcw.home.local> <4C7B5EA1-AE40-4E64-92CC-24277900A99E@yahoo.com> <4F2F2445.9080604@cn.fujitsu.com> <613D92FB-4573-4301-BC1A-8DA114FE2A5F@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <613D92FB-4573-4301-BC1A-8DA114FE2A5F@yahoo.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 05:14:26PM -0800, Luben Tuikov wrote:
> Where is the "From:" tag that would appear in "git log"?

Here's the complete patch scheduled for merging :

	From da229078845ada4d7b0b49a020c8eaf49420cec9 Mon Sep 17 00:00:00 2001
	From: Luben Tuikov <ltuikov@yahoo.com>
	Date: Tue, 26 Jul 2011 23:10:48 -0700
	Subject: libsas: remove expander from dev list on error

	commit 5911e963d3718e306bcac387b83e259aa4228896 upstream.

	If expander discovery fails (sas_discover_expander()), remove the
	expander from the port device list (sas_ex_discover_expander()),
	before freeing it. Else the list is corrupted and, e.g., when we
	attempt to send SMP commands to other devices, the kernel oopses.

	Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
	Reviewed-by: Jack Wang <jack_wang@usish.com>
	Signed-off-by: James Bottomley <JBottomley@Parallels.com>
	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
	---
	 drivers/scsi/libsas/sas_expander.c |    3 +++
	 1 files changed, 3 insertions(+), 0 deletions(-)

	Index: longterm-2.6.27/drivers/scsi/libsas/sas_expander.c
	===================================================================
	--- longterm-2.6.27.orig/drivers/scsi/libsas/sas_expander.c     2012-02-05 22:34:34.059914940 +0100
	+++ longterm-2.6.27/drivers/scsi/libsas/sas_expander.c  2012-02-05 22:34:39.404915902 +0100
	@@ -839,6 +839,9 @@
	 
		res = sas_discover_expander(child);
		if (res) {
	+               spin_lock_irq(&parent->port->dev_list_lock);
	+               list_del(&child->dev_list_node);
	+               spin_unlock_irq(&parent->port->dev_list_lock);
			kfree(child);
			return NULL;
		}

You're clearly the one who's credited for the patch, both by the From: and
Signed-off-by tags. I am always very careful about credit attributions, and
that's even what scares me when I have to force to apply patches by hand.
I think you were surprized not to see you in the From just because of the
way the review scripts assembles the patches in mails.  I'm using quilt this
way to build the mails :

   quilt mail \
     -m "$(sed -e "s/XX\.YY/$SUBLEVEL.$REV/g" .quilt/header;git diff --stat)" \
     --from "$GIT_COMMITTER_NAME <$GIT_COMMITTER_EMAIL>" \
     --subject "$VERSION.$PATCHLEVEL.$SUBLEVEL.$REV-longterm review" \
     --prefix "PATCH" \
     --to "linux-kernel@vger.kernel.org, stable@vger.kernel.org" \
     --mbox mbox

I don't think there's anything wrong with this. I you have suggestions to
improve the output readability, feel free to suggest so.

Best regards,
Willy

