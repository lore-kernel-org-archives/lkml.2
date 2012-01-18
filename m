Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab2ARRzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:55:15 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58724 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab2ARRzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:55:12 -0500
Message-ID: <4F170759.5010300@linux.vnet.ibm.com>
Date: Wed, 18 Jan 2012 23:24:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sergei Trofimovich <slyich@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        "gouders@et.bocholt.fh-gelsenkirchen.de" 
	<gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        "justinmattock@gmail.com" <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
References: <20120118144250.GA16288@suse.de> <Pine.LNX.4.44L0.1201181047060.1343-100000@iolanthe.rowland.org> <3908561D78D1C84285E8C5FCA982C28F01CF24@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F01CF24@ORSMSX104.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011817-4790-0000-0000-000000EEA6BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 10:58 PM, Luck, Tony wrote:

> Greg said:
>> It was already fixed that way, but the problem is that you can not have
>> statically allocated 'struct device' objects in the system.
> 
> and then Alan said:
>> There's an additional requirement: Device structures may not be reused.  
>> Not even if the caller clears all the fields to 0 in between.  That was
>> the real bug in the original code -- and adding a dummy release routine
>> wouldn't fix it.
> 
> There seems to be some curious logic happening here which I don't understand
> at all. How can the code that deals with 'struct device' tell whether it was
> statically declared or dynamically allocated? Why would it care?
> 
> What happens if we play by the rules using a dynamic structure and do
> 
>  device_register() + device_create_file(dev)
>    ...
>  device_remove_file(dev) + device_unregister()
> 
> then later come back to re-add this and by pure random fluke kzalloc()
> gives us back the exact same block of memory that we used for dev before?
> 
> By Alan's logic we are screwed - we are re-using the same device structure
> (unless kfree() + kzalloc() does some magic pixie dust thing so that this
> same block of memory is now not the same device structure we had before, even
> though it has the same address).
> 
> In summary - I can totally buy the argument that you must start with a zeroed
> struct device (and that it is just fine that device_unregister() doesn't waste
> cpu cycles cleaning up the structure just in case someone will re-use it, because
> that isn't going to be the common case).
> 
> I just don't understand the magical difference between a static structure that
> has been memset() to all zero, and a dynamic block returned from kzalloc().
> 


I am in total agreement with what Tony said above. We have already seen that
my patch did a memset of the device structure and solved the suspend issue.
So, the suspend issue is no longer haunting us, which demonstrates that there
is really no difference between using a zeroed struct device vs using a
structure which is dynamically allocated using zalloc().

What Greg is trying to do with this patch is - get rid of the "Machinecheck
doesn't have release() function" warning in a proper way - something better
than having a dummy release function. Functionality-wise, that patch is not
fixing anything!

Regards,
Srivatsa S. Bhat

