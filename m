Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1LTC7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 21:59:09 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:33322 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1LTC7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 21:59:06 -0500
Date: Mon, 19 Dec 2011 20:58:48 -0600
From: David Fries <david@fries.net>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arek Lichwa <arkadiusz.lichwa@tieto.com>, iliak@ti.com,
        ulrik.lauren@stericsson.com, peter@hurleysoftware.com
Subject: Re: [REGRESSION] 3.2.0-rc3 Bluetooth L2CAP Linux to Linux rfcomm
 fails
Message-ID: <20111220025848.GH3298@spacedout.fries.net>
References: <1319621002-7122-1-git-send-email-arkadiusz.lichwa@tieto.com>
 <20111031190129.GA10164@joana>
 <20111211051624.GA12050@spacedout.fries.net>
 <20111219003652.GN2621@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219003652.GN2621@joana>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Mon, 19 Dec 2011 20:58:51 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 18, 2011 at 10:36:52PM -0200, Gustavo Padovan wrote:
> Hi David,
> 
> * David Fries <david@fries.net> [2011-12-10 23:16:24 -0600]:
> 
> > On Mon, Oct 31, 2011 at 05:01:29PM -0200, Gustavo Padovan wrote:
> > > Hi Arek,
> > > 
> > > * Arek Lichwa <arkadiusz.lichwa@tieto.com> [2011-10-26 11:23:21 +0200]:
> > > 
> > > > Hi
> > > > 
> > > > We found during testing problem when setting rfcomm (SPP) channel between
> > > > two 2.1 devices. 
> > > > The test case always failed mostly saying security block on l2cap level 
> > > > but sometimes the fail root cause was 'Command not understood' on l2cap 
> > > > as well.
> > > > Analyzing security block issue, I found that there's unencrypted link when
> > > > l2cap command 'connection request' is sent to remote.
> > > > The second issue with 'command not understood' has turn out to be related to 
> > > > expiration of l2cap timer and its implications.
> > > > 
> > > > Solution that I found to fix the problem seems to be related to old commit 
> > > > 330605423ca6eafafb8dcc27502bce1c585d1b06 made by Ilia Kolomisnky. When there's
> > > > authentication ongoing, 'encryption pending' should be turn on, otherwise 
> > > > there're situations when link stays unencrypted. 
> > > > The issue with timer expiration is related to Andrzej Kaczmarek's patch 
> > > > sent to community a couple days ago (~ 2011/10/20). 
> > > > This patch actually recalculates (repairs) timer values on l2cap which were 
> > > > wrongly converted before. 
> > > > With this patch the expiration issue disappears during the test case 
> > > > I've made, otherwise just reverting 330605423ca6eafafb8dcc27502bce1c585d1b06
> > > > is not enough, since timer issue blocks very often passing the test case.
> > > 
> > > Are you saying that Andrzej's patch together with revert of 330605423 fixes
> > > the problem? and are you sure that we are not creating any new regression?
> > > 
> > > 	Gustavo
> > 
> > I just found that I can't connect rfcomm any more from Linux (desktop)
> > to Linux (N900) with bluetooth.  On the desktop side, 3.2.0-rc2 works,
> > but 3.2.0-rc3 (and on) fails, I even merged in
> > git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-next
> > master 5a13b09531420d230616bd524b68a5b0c23cd487 without any change.
> > Fortunately there were only three bluetooth patches between rc2 and rc3.
> > Reverting 4dff523a913197e3314c7b0d08734ab037709093 fixed the issue and
> > I can connect again.
> 
> I wen ahead and reverted this one.
> 
> 	Gustavo

Thanks.  It's unfortunate that it seems some devices seem to have
mutually incompatible options.  I'll volunteer to test against the
N900 if there are any patches in the future that try to make both
types work if I'm made aware of the change.

Here's the N900 kernel-power's net/bluetooth/hci_conn.c
at least it was interesting to me that it does the test_and_set_bit
that causes my desktop to be unable to connect with it.  N900 is based
on 2.6.28 though the N900 version of that file is almost a match with
2.6.31.

/* Enable security */
int hci_conn_security(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
{
	BT_DBG("conn %p", conn);

	if (sec_level == BT_SECURITY_SDP)
		return 1;

	if (sec_level == BT_SECURITY_LOW &&
				(!conn->ssp_mode || !conn->hdev->ssp_mode))
		return 1;

	if (conn->link_mode & HCI_LM_ENCRYPT)
		return hci_conn_auth(conn, sec_level, auth_type);

	if (test_and_set_bit(HCI_CONN_ENCRYPT_PEND, &conn->pend))
		return 0;

	if (hci_conn_auth(conn, sec_level, auth_type)) {
		struct hci_cp_set_conn_encrypt cp;
		cp.handle  = cpu_to_le16(conn->handle);
		cp.encrypt = 1;
		hci_send_cmd(conn->hdev, HCI_OP_SET_CONN_ENCRYPT,
							sizeof(cp), &cp);
	}

	return 0;
}

After failing to connect to the N900 both with and without it reverted
I rebooted the N900, and double checked.  I could connect with
4dff523a913197e33 reverted, but I still got the 'Connection reset by
peer' without the patch reverted, not sure what went wrong on the N900
for a bit to cause both to fail and yet connect to bluetooth audio
devices, but it does need it reverted to work.

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
