Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab0JZRpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:45:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60117 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab0JZRpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:45:45 -0400
Date: Tue, 26 Oct 2010 18:45:40 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corey Minyard <cminyard@mvista.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipmi: Run a dummy command before submitting a new
	command
Message-ID: <20101026174540.GA15395@srcf.ucam.org>
References: <1280246493-964-1-git-send-email-mjg@redhat.com> <4C4F123F.3010700@mvista.com> <20100727172100.GC7324@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727172100.GC7324@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've finally had time to look at this more closely. The following patch 
seems to make things happy, but I still don't have a full understanding 
of what's going on.

(Background: Some HP ilo firmware versions are unhappy due to 
3326f4f2276791561af1fd5f2020be0186459813 . Running a dummy command in 
schedule() works around this but clearly isn't the right answer. Turns 
out that this also breaks IPMI on some Suns, and Oracle reverted this in 
their kernel but never told me. Thoracle)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index e537610..763af8f 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -901,6 +901,8 @@ static void sender(void                *send_info,
 
 	mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
 
+	smi_info->last_timeout_jiffies = jiffies;
+
 	if (smi_info->thread)
 		wake_up_process(smi_info->thread);
 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
