Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1FHRIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:08:46 -0400
Received: from realvnc.com ([146.101.152.142]:45235 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab1FHRIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:08:44 -0400
Message-ID: <4DEFAC9A.9030106@realvnc.com>
Date: Wed, 08 Jun 2011 18:08:42 +0100
From: Toby Gray <toby.gray@realvnc.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: cdc-acm: Prevent loss of data when filling tty buffer
References: <1307547519-29246-1-git-send-email-toby.gray@realvnc.com> <20110608164626.22bc893c@lxorguk.ukuu.org.uk>
In-Reply-To: <20110608164626.22bc893c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2011 16:46, Alan Cox wrote:
>> This patch adds checking for how many bytes have been inserted into the tty
>> buffer and places data which hasn't been inserted into a pending buffer list.
>> The pending buffer list is pushed to the tty buffer when the tty unthrottles
> I don't think this is the way to tackle it.
Fair enough. I wasn't 100% sure that adding what is really an extra 
layer of buffering in the driver was the best solution.
> If the kernel tty buffer code is shedding data then not only have we
> asserted a throttle but 64K has been accumulated or the system is out of
> memory.
>
> So the questions to me are:
>
> a) Why is your setup filling 64K in the time it takes the throttle
> response to occur
The setup is a Nokia mobile phone sending some application data over a 
USB connection. Applications running on Nokia's Symbian based mobile 
phones which wish to communicate with a PC over USB are offered a 
virtual COM port on the mobile phone side. This COM port appears as a 
second cdc-acm device to the PC.

In this particular instance the device is sending a large quantity of 
data (about 1MB) down the COM port. This communication is one way, so 
the device keeps sending the data as fast as the PC requests more USB 
bulk transfers.

If it hasn't been told to throttle then the cdc-acm code will issue more 
bulk reads as soon as the last one has completed. This means that it's 
possible for the tty to not have a chance to be throttle by 
flush_to_ldisc before too much data has been received over USB.
> b) Do we care (is the right thing to do to lose bits anyway at that point)
The cdc-acm driver which Nokia provide for Windows doesn't drop data 
when transferring large volumes of data, so most application making use 
of the mobile phone to PC USB connection won't have implemented any form 
of error correction or retransmission. If we don't care about data loss 
on Linux then it will force the application layer to implement some way 
of detecting these losses and to then retransmit the data.

> c) What should we do about it in the *general* case
> It seems to me either its a cdc-acm specific problem with throttle
> response behaviour, or its a general case at very high speed (which seems
> more likely). In neither case is adding an extra queue to paper over it
> the right solution.
Agreed. I'm not sure about how specific to cdc-acm it is though. I think 
the reason that I'm seeing this problem is due to the high data rate of 
USB combined with the protocol that is being used over the cdc-acm 
channel not having any flow control or acknowledgements. I have no idea 
how specialist this situation is though.

I think a possible alternative solution for the cdc-acm would be for it 
to make sure that tty_buffer_request_room returns enough space for any 
pending URB requests. However I think I originally dismissed this as a 
possibility as I couldn't think of an easy way for the cdc-acm driver to 
be told that more buffer room has been made available.

Regards,

Toby

