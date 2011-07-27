Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1G0M3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:29:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38536 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751142Ab1G0M3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:29:09 -0400
Date: Wed, 27 Jul 2011 13:32:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Ott <alan@signal11.us>
Cc: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: IP over 802.2 with LLC/SNAP
Message-ID: <20110727133209.0d9dd6c4@lxorguk.ukuu.org.uk>
In-Reply-To: <4E2F8B7B.80906@signal11.us>
References: <4E2F8B7B.80906@signal11.us>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the question is, does Linux support IP over 802.2 with LLC/SNAP? Is 
> there a sysfs/proc entry that I have to turn on to make this work (I 
> didn't find one)? I have the LLC2 module loaded, and I believe my packet 
> to be correct, since Windows recognizes it and since Wireshark doesn't 
> give any red flags on it. I've been unable to find anything about this 
> kind of thing in my searching.

Linux supports LLC/SNAP and various things over it (IPX/Appletalk DDP
etc) but not IP over it, as it's one of those standards bodies driven
bogosities which nobody ever actually deployed.

You are about the first person in the known universe to care 8). Now
there isn't any reason for not supporting it. The receive side is a case
of using register_snap_client() and piping the frames into the IP stack.

The send side could be tackled two ways I can see, one would be to allow
for snap protocols to be set somehow on devices and routes, the other
that might be simply would be to create a 'snapifier' device that added
snap headers then routed the frame via the bound physical device as
802.2 LLC. That way you'd be able to do

	route add gould-relic dev snap0

In both cases you'd need to tackle ARP but that seems to need no
configuration as SNAP requests get SNAP replies, and so on.

It should be a 'simple matter of hacking' and there are example devices
that fiddle with packets and add headers etc you can nick a lot of code
from. I figure if you can write an IP stack for an ancient Gould system
you can probably do that.

The other way is to use the Linux raw packet interfaces, open a raw
socket, push a BPF filter onto it to just get the frames for IP/SNAP and
ARP/SNAP then modify them and feed them to the kernel tun/tap interface.

Alan
