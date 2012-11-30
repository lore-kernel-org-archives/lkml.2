Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030995Ab2K3QYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:24:12 -0500
Received: from atl4mhob12.myregisteredsite.com ([209.17.115.50]:54084 "EHLO
	atl4mhob12.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932472Ab2K3QYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:24:10 -0500
X-Greylist: delayed 46598 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2012 11:24:10 EST
Message-ID: <50B8DDAC.8070901@microgate.com>
Date: Fri, 30 Nov 2012 10:24:12 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Suggestion] drivers/tty: drivers/char/:  for MAX_ASYNC_BUFFER_SIZE
References: <50B6E751.9000000@asianux.com> <20121129051335.GA4375@kroah.com> <50B6F967.3050000@asianux.com> <20121129183207.GA4688@kroah.com> <50B81F76.8020508@asianux.com>
In-Reply-To: <50B81F76.8020508@asianux.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 8:52 PM, Chen Gang wrote:
> 于 2012年11月30日 02:32, Greg KH 写道:
>> On Thu, Nov 29, 2012 at 01:57:59PM +0800, Chen Gang wrote:
>>>> And, I really don't understand here, why do you want to change this?
>>>> What is it going to change?  And why?
>>>
>>> Why:
>>>   for the context MGSLPC_INFO *info in drivers/char/pcmcia/synclink_cs.c
>>>     info->max_frame_size can be the value between 4096 .. 65535 (can be
>>> set by its module input parameter)
>>>     info->flag_buf length is 4096 (MAX_ASYNC_BUFFER_SIZE)
>>>   in function rx_get_frame
>>>     the framesize is limit by info->max_frame_size, but may still be
>>> larger that 4096.
>>>     when call function ldisc_receive_buf, info->flag_buf is equal to
>>> 4096, but framesize can be more than 4096. it will cause memory over flow.

The confusion centers on calling the line discipline receive_buf
function with a data buffer larger than the flag buffer.

The synclink drivers support asynchronous and synchronous (HDLC)
serial communications.

In asynchronous mode, the tty flip buffer is used to feed
data to the line discipline. In this mode, the above argument
does not apply. The receive_buf function is not called directly.

In synchronous mode, the driver calls the line discipline
receive_buf function directly to feed one HDLC frame
of data per call. Maintaining frame boundaries is needed
in this mode. This is done only with the N_HDLC line
discipline which expects this format and ignores the flag buffer.
The flag buffer passed is just a place holder to meet the
calling conventions of the line discipline receive_buf function.

The only danger is if:
1. driver is configured for synchronous mode
2. driver is configured for frames > 4K
3. line discipline other than N_HDLC is selected

In this case the line discipline might try to access
beyond the end of the flag buffer. This is a non-functional
configuration that would not occur on purpose.

Increasing the flag buffer size would prevent a problem
in this degenerate case of purposeful misconfiguration.
This would be at the expense of larger allocations that are
not used.

I think the correct fix is for me to change the direct
calls to pass the same buffer for both data and flag and
add a comment describing the fact the flag buffer is ignored
when using N_HDLC. That way a misconfigured setup won't
cause problems and no unneeded allocations are made.

My suggestion is to leave it as is for now until I can make
those changes. I admit the current code is ugly enough to
cause confusion (sorry Chen Gang), but I don't see any immediate danger.

-- 
Paul Fulghum
MicroGate Systems, Ltd.
=Customer Driven, by Design=
(800)444-1982 (US Sales)
(512)345-7791 x102 (Direct)
(512)343-9046 (Fax)
Central Time Zone (GMT -6h)
www.microgate.com
