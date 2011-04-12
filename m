Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab1DLSJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:09:12 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55743 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab1DLSJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:09:10 -0400
Date: Tue, 12 Apr 2011 15:09:33 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        Keith Packard <keithp@keithp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume
 b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
Message-ID: <20110412180933.GA2836@joana>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
	Keith Packard <keithp@keithp.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org
References: <yun1v1fj024.fsf@aiko.keithp.com>
 <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6>
 <alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6>
 <yunaag0tjzb.fsf@aiko.keithp.com>
 <20110409000857.GB25581@piper>
 <alpine.LFD.2.00.1104111807480.4501@localhost6.localdomain6>
 <1302558033.2572.219.camel@aeonflux>
 <alpine.LFD.2.00.1104120014130.2702@localhost6.localdomain6>
 <alpine.LFD.2.00.1104120016490.2702@localhost6.localdomain6>
 <20110411222504.GE2195@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20110411222504.GE2195@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gustavo F. Padovan <padovan@profusion.mobi> [2011-04-11 19:25:04 -0300]:

> * Thomas Gleixner <tglx@linutronix.de> [2011-04-12 00:19:32 +0200]:
> 
> > On Tue, 12 Apr 2011, Thomas Gleixner wrote:
> > > On Mon, 11 Apr 2011, Marcel Holtmann wrote:
> > > 
> > > > Hi Thomas,
> > > > 
> > > > > > > > Can the bluetooth folks please have a look at that ASAP? The obvious
> > > > > > > > fast fix for Linus tree is to revert the second hunk for now, but this
> > > > > > > > needs to be fixed proper.
> > > > > > > 
> > > > > > > Who will submit this patch? I'd rather have your name on it so that
> > > > > > > people come complain at you...
> > > > > > 
> > > > > > I took a shot at it and just sent a patch (also attached for convenience) 
> > > > > > that should solve the problem.
> > > > > 
> > > > > Aaarg. No. That patch reverts both hunks.
> > > > > 
> > > > > --- a/net/bluetooth/hci_core.c
> > > > > +++ b/net/bluetooth/hci_core.c
> > > > > @@ -586,9 +586,6 @@ static int hci_dev_do_close(struct hci_dev *hdev)
> > > > >  	hci_req_cancel(hdev, ENODEV);
> > > > >  	hci_req_lock(hdev);
> > > > >  
> > > > > -	/* Stop timer, it might be running */
> > > > > -	del_timer_sync(&hdev->cmd_timer);
> > > > > -
> > > > >  	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
> > > > >  		hci_req_unlock(hdev);
> > > > >  		return 0;
> > > > > 
> > > > > As I said before you need that first hunk to stay for the case where
> > > > > there is no device up and you return via the !HCI_UP check. You just
> > > > > moved back to the state before as the stupid timer is active for
> > > > > whatever reason even when HCI_UP is not set.
> > > > 
> > > > if I read this right then we have the case that we arm this timer for no
> > > > real reason. A device in !HCI_UP should have nothing running. Certainly
> > > > not the cmd_timer since it will never process any commands.
> > > > 
> > > > According to Gustavo, the problem is really in the hci_reset logic were
> > > > we arm the timer even when shutting down the device.
> > > 
> > > The reason why the original patch was sent is, that the timer was
> > > running when the thing went out via the !HCI_UP path, which caused the
> > > whole thing to explode in the first place. I had no time to figure out
> > > why, but moving the del_timer_sync above the
> > > if (!test_and_clear_bit(HCI_UP, &hdev->flags)) solved it.
> > 
> > Oops. Hit send too fast.
> > 
> > Then it broke the resume on Keith machine and reverting just the hunk
> > which disarms the timer in the 
> > 
> >         if (hdev->sent_cmd) {
> > 
> > path made both scenarios working. So there are two problems:
> > 
> >      1) Why do we need the del_timer_sync() above the !HCI_UP check
> 
> That is still a mysterious to me, the real bug the hiding here. I'm trying to
> track this down but no luck yet.
> 
> > 
> >      2) Why gets the timer rearmed after that
> 
> It is armed at each HCI command we send. In the close path we send out an HCI
> RESET command that rearms it.

I applied v2 patch from Vinícius that fix all the symptoms. Now we have more time
to find the real cause of this bug. However I still have no idea, I'm not able
to reproduce it.

-- 
Gustavo F. Padovan
http://profusion.mobi
