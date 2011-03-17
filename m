Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1CQQmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 12:42:44 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:15242 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596Ab1CQQmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 12:42:40 -0400
Message-ID: <4D8239FA.50208@caviumnetworks.com>
Date: Thu, 17 Mar 2011 09:42:34 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-serial@vger.kernel.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca
Subject: Re: [RFC PATCH 1/2] serial: 8250: Add a notifier chain for driver
 registration.
References: <1300325167-26433-1-git-send-email-ddaney@caviumnetworks.com>	<1300325167-26433-2-git-send-email-ddaney@caviumnetworks.com> <20110317121849.49d7c425@lxorguk.ukuu.org.uk>
In-Reply-To: <20110317121849.49d7c425@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2011 16:42:39.0363 (UTC) FILETIME=[53F64D30:01CBE4C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2011 05:18 AM, Alan Cox wrote:
> On Wed, 16 Mar 2011 18:26:06 -0700
> David Daney<ddaney@caviumnetworks.com>  wrote:
>
>> The 8250 driver is a bit weird in that in addition to supporting
>> platform devices, extra devices can be added by calling
>> serial8250_register_port().
>>
>> The problem is that if we call serial8250_register_port() before the
>> driver is initialized Bad Things happen (we dereference NULL
>> pointers).
>>
>> There doesn't seem to be a general way to know if a driver has been
>> initialized
>
> I've had a bigger dig into this. I think the correct answer is probably
> "always go via platform devices or similar". That *is* the notifier in
> the kernel of today. serial8250_register_port ultimately should I think
> ultimatly become an internal helper.
>

That was kind of my thought too.  However we have all sorts of things 
calling serial8250_register_port(). Things like:

8250_pci.c
of_serial.c
8250_acorn.c
8250_gsc.c
.
.
.

The resulting view of the drivers in sysfs is that the little stub code 
that calls serial8250_register_port() is shown as the driver rather than 
serial8250.  But I suppose that is a matter of aesthetics more than 
function.

All those 'stub drivers' are relying on the ordering of module_init 
calls caused indirectly by the Makefile layout.  The path of least 
resistance is your suggestion that I use late_initcall() in my driver 
stub.  I actually tried that before hacking up this patch, but didn't 
like the idea of relying on *_initcall() ordering being necessary for 
correct initialization.

David Daney
