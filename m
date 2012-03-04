Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2CDBuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 20:50:11 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62208 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2CDBuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 20:50:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of chunkeey@googlemail.com designates 10.14.52.133 as permitted sender) smtp.mail=chunkeey@googlemail.com; dkim=pass header.i=chunkeey@googlemail.com
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is not yet available
Date: Sun, 4 Mar 2012 02:50:02 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc4-wl+; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
References: <201203032122.36745.chunkeey@googlemail.com> <20120303235704.2df2b040@pyramind.ukuu.org.uk>
In-Reply-To: <20120303235704.2df2b040@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203040250.02790.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 March 2012 00:57:04 Alan Cox wrote:
> On Sat, 3 Mar 2012 21:22:36 +0100
> Christian Lamparter <chunkeey@googlemail.com> wrote:
> 
> > During resume, the userhelper might not be available. However for
> > drivers which use the request_firmware_nowait interface, this will
> > only lead to a pointless WARNING and a device which no longer works
> > after the resume [since it couldn't get the firmware, because the
> > userhelper was not available to take the request].
> 
> Can you not load the firmware on the suspend path ?
>
If I could, I would fetch the firmware "open" as it is supposed to be.
But, but the driver's "remove" op is called during resume by the "bus".
So, everything will vanish with it.

But see for yourself: In my case I have to deal with a pci-chip [isl3886,
p54pci driver] that comes on board of a cardbus card. The code that
does the "unbind/rebind" is in drivers/pcmcia/cs.c, function: socket_late_resume

>	if (skt->state & SOCKET_CARDBUS) {
>		/* We can't be sure the CardBus card is the same
>		 * as the one previously inserted. Therefore, remove
>		 * and re-add... */
>		cb_free(skt);
>		cb_alloc(skt);
>		return 0;
>	}
Of course cb_free(...) is just a elaborate way of saying:
	pci_remove_behind_bridge(pcmcia_socket);
[And cb_alloc obviously just re-"probe"s the device in the
cardbus socket again...]

Of course, in my case, I could tuck the firmware away in a some
static const struct firmware* somewhere within the driver code.
But then someone [like you :-D] will yell at me for hiding it in a
file-global stash of ugliness.

Regards,
	Christian
