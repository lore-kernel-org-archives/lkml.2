Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0FCVD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:03:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751993Ab0FCVDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:03:55 -0400
Date: Thu, 3 Jun 2010 13:59:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: floppy driver assumes INITIAL_JIFFIES == 0
In-Reply-To: <alpine.LFD.2.00.1006031204470.8175@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006031355140.8175@i5.linux-foundation.org>
References: <20100603101501.5e5d7148@nehalam> <alpine.LFD.2.00.1006031013060.8175@i5.linux-foundation.org> <20100603120313.10a73b20@nehalam> <alpine.LFD.2.00.1006031204470.8175@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Linus Torvalds wrote:
> 
> But I don't see why. I'll dig around the timer stuff a bit more. If it 
> only happens with that INITIAL_JIFFIES thing, it must be clearly somehow 
> related to a timer happening (or not happening) too early.

Hmm. I don't see anything. In most cases, having whatever variable 
pointing to jiffies in the future (which 0 would be for the 
INITIAL_JIFFIES case) should be fine - at most it would make the timeout 
way too long, not break anything. They tend to be bases for timeouts, ie 
you have things like

	fd_wait_for_completion(DRS->select_date + DP->select_delay, ...

where we set a timeout based on when we did something.

The one case that seems iffy for is "last_checked", which contains when we 
last checked the disk change state. It being in the future could cause 
problems, since it would make us think that a disk change state is valid 
when it really shouldn't be.

Anyway, does this patch make any difference? It just makes floppy 
initialization set up some of those fields too.

Untested. I don't have the hardware.

		Linus

---
 drivers/block/floppy.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 90c4038..c7e83de 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4180,6 +4180,8 @@ static int __init floppy_init(void)
 		return -ENODEV;
 #endif
 
+	set_debugt();
+
 	raw_cmd = NULL;
 
 	for (dr = 0; dr < N_DRIVE; dr++) {
@@ -4267,6 +4269,9 @@ static int __init floppy_init(void)
 		set_bit(FD_DISK_CHANGED_BIT, &UDRS->flags);
 		set_bit(FD_VERIFY_BIT, &UDRS->flags);
 		UDRS->fd_device = -1;
+		UDRS->last_checked = jiffies;
+		UDRS->select_date = jiffies;
+		UDRS->spinup_date = jiffies;
 		floppy_track_buffer = NULL;
 		max_buffer_sectors = 0;
 	}
