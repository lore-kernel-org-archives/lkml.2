Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1DKVki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:40:38 -0400
Received: from senator.holtmann.net ([87.106.208.187]:52191 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1DKVkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:40:37 -0400
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume
 b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
From: Marcel Holtmann <marcel@holtmann.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        Keith Packard <keithp@keithp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1104111807480.4501@localhost6.localdomain6>
References: <yun1v1fj024.fsf@aiko.keithp.com>
	 <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6>
	 <alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6>
	 <yunaag0tjzb.fsf@aiko.keithp.com> <20110409000857.GB25581@piper>
	 <alpine.LFD.2.00.1104111807480.4501@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Apr 2011 23:40:33 +0200
Message-ID: <1302558033.2572.219.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

> > > > Can the bluetooth folks please have a look at that ASAP? The obvious
> > > > fast fix for Linus tree is to revert the second hunk for now, but this
> > > > needs to be fixed proper.
> > > 
> > > Who will submit this patch? I'd rather have your name on it so that
> > > people come complain at you...
> > 
> > I took a shot at it and just sent a patch (also attached for convenience) 
> > that should solve the problem.
> 
> Aaarg. No. That patch reverts both hunks.
> 
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -586,9 +586,6 @@ static int hci_dev_do_close(struct hci_dev *hdev)
>  	hci_req_cancel(hdev, ENODEV);
>  	hci_req_lock(hdev);
>  
> -	/* Stop timer, it might be running */
> -	del_timer_sync(&hdev->cmd_timer);
> -
>  	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
>  		hci_req_unlock(hdev);
>  		return 0;
> 
> As I said before you need that first hunk to stay for the case where
> there is no device up and you return via the !HCI_UP check. You just
> moved back to the state before as the stupid timer is active for
> whatever reason even when HCI_UP is not set.

if I read this right then we have the case that we arm this timer for no
real reason. A device in !HCI_UP should have nothing running. Certainly
not the cmd_timer since it will never process any commands.

According to Gustavo, the problem is really in the hci_reset logic were
we arm the timer even when shutting down the device.

Regards

Marcel


