Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1CXMvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:51:49 -0400
Received: from realvnc.com ([146.101.152.142]:34948 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab1CXMvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 08:51:47 -0400
Message-ID: <4D8B3E61.1090704@realvnc.com>
Date: Thu, 24 Mar 2011 12:51:45 +0000
From: Toby Gray <toby.gray@realvnc.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: balbi@ti.com
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stefan Bigler <stefan.bigler@keymile.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
References: <4D8121F6.9060600@keymile.com> <20110317000408.GA18911@kroah.com> <4D8389EC.5030704@keymile.com> <20110318170801.GA2857@legolas.emea.dhcp.ti.com> <20110318180657.11570887@lxorguk.ukuu.org.uk> <20110321093255.GE1837@legolas.emea.dhcp.ti.com> <20110322085344.GN1837@legolas.emea.dhcp.ti.com> <4D8B341C.4010406@realvnc.com> <20110324123708.GK14602@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110324123708.GK14602@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/03/2011 12:37, Felipe Balbi wrote:
> Hi,
>
> On Thu, Mar 24, 2011 at 12:07:56PM +0000, Toby Gray wrote:
>> Is this patch missing the changes to tty_buffer.c that were in
>> http://permalink.gmane.org/gmane.linux.usb.general/28976
>>
>> Without the changes to tty_buffer.c to use the value returned from
>> the receive_buf call then doesn't this patch not work correctly?
>>
<snip>
> you are right, thanks for noticing that. Attached is an updated patch.
> I left removal of receive_room out of this patch to prevent too invasive
> change, that can be done on a separate patch.

I've just tried removing receive_room myself and noticed that it is 
still used in flush_to_ldisc to decide if it needs to schedule work to 
be done later:

    if (!tty->receive_room || seen_tail) {
       schedule_work(&tty->buf.work);
       break;
    }

If receive_room is no longer being updated then isn't this the wrong 
thing to do? Shouldn't it check if some data was copied after calling 
receive_buf, and if there wasn't any then it should schedule the work 
and break?

The other query I've got is about the return value from receive_buf. I 
noticed that you've modified some drivers (such as 
bluetooth/hci_ldisc.c) so that they can return error values, such as 
-ENODEV. Won't this cause things to go wrong when flush_to_ldisc and 
paste_selection use the return value without checking for it being negative?

Thank you for your quick reply to my first query, it's appreciated.

Regards,

Toby
