Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1DKQMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:12:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:52144 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1DKQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:12:29 -0400
Date: Mon, 11 Apr 2011 18:12:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
cc: Keith Packard <keithp@keithp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume
 b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
In-Reply-To: <20110409000857.GB25581@piper>
Message-ID: <alpine.LFD.2.00.1104111807480.4501@localhost6.localdomain6>
References: <yun1v1fj024.fsf@aiko.keithp.com> <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6> <alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6> <yunaag0tjzb.fsf@aiko.keithp.com> <20110409000857.GB25581@piper>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Apr 2011, Vinicius Costa Gomes wrote:

> Hi Keith,
> 
> On 16:13 Fri 08 Apr, Keith Packard wrote:
> > On Fri, 8 Apr 2011 23:44:51 +0200 (CEST), Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > Can the bluetooth folks please have a look at that ASAP? The obvious
> > > fast fix for Linus tree is to revert the second hunk for now, but this
> > > needs to be fixed proper.
> > 
> > Who will submit this patch? I'd rather have your name on it so that
> > people come complain at you...
> 
> I took a shot at it and just sent a patch (also attached for convenience) 
> that should solve the problem.

Aaarg. No. That patch reverts both hunks.

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -586,9 +586,6 @@ static int hci_dev_do_close(struct hci_dev *hdev)
 	hci_req_cancel(hdev, ENODEV);
 	hci_req_lock(hdev);
 
-	/* Stop timer, it might be running */
-	del_timer_sync(&hdev->cmd_timer);
-
 	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
 		hci_req_unlock(hdev);
 		return 0;

As I said before you need that first hunk to stay for the case where
there is no device up and you return via the !HCI_UP check. You just
moved back to the state before as the stupid timer is active for
whatever reason even when HCI_UP is not set.

@@ -618,6 +615,9 @@ static int hci_dev_do_close(struct hci_dev *hdev)
 		clear_bit(HCI_INIT, &hdev->flags);
 	}
 
+	/* Stop timer, it might be running */
+	del_timer_sync(&hdev->cmd_timer);
+
 	/* Kill cmd task */
 	tasklet_kill(&hdev->cmd_task);
