Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1BEQRq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 11:17:46 -0500
Received: from gw1.transmode.se ([213.115.205.20]:56634 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab1BEQRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 11:17:43 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Feb 2011 11:17:43 EST
Subject: barrier question
X-KeepSent: 7CDB8A02:07DC9F04-C125782E:00582B5A;
 type=4; name=$KeepSent
To: LKML <linux-kernel@vger.kernel.org>
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OF7CDB8A02.07DC9F04-ONC125782E.00582B5A-C125782E.0058E203@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Sat, 5 Feb 2011 17:10:50 +0100
X-MIMETrack: Serialize by Router on sesr04/Transmode(Release 8.5.2FP1|November 29, 2010) at
 2011-02-05 17:10:51
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looking for a bug in the cfi_cmd0001.c flash driver and I wonder
if the following is enough for chip->state to be reloaded every time it
accessed or if some barrier is needed:


	int chip_state = chip->state; /* save state before dropping lock */


	mutex_unlock(&chip->mutex);
	if (inval_len)
		INVALIDATE_CACHED_RANGE(map, inval_adr, inval_len);
	mutex_lock(&chip->mutex);


	for (;;) {
		while (chip->state != chip_state) {
			/* Someone's suspended the operation: sleep */
			DECLARE_WAITQUEUE(wait, current);
			set_current_state(TASK_UNINTERRUPTIBLE);
			add_wait_queue(&chip->wq, &wait);
			mutex_unlock(&chip->mutex);
			schedule();
			remove_wait_queue(&chip->wq, &wait);
			mutex_lock(&chip->mutex);
		}
...
	}

 Jocke

