Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab1ICAv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 20:51:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51003 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1ICAv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 20:51:26 -0400
Message-ID: <4E617A3B.1090803@gmail.com>
Date: Sat, 03 Sep 2011 04:52:11 +0400
From: George Shuklin <george.shuklin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Icedove/3.1.12
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org
Subject: Re: si_swapinfo export
References: <1314978089.11870.2.camel@mabase> <3187.1314993238@turing-police.cc.vt.edu>
In-Reply-To: <3187.1314993238@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, in my personal case it is some 'memory pressure service' for 
virtual machines in xen environment.

It check about 1-2 times per second memory state and report it to 
management software outside VM. Right now this is userspace program, 
which reads /proc/meminfo and sends it via xenstore (interdomain 
communication system) to management domain. It works fine, but we need 
to do double int-str conversion (/proc/meminfo do itoa, our daemon sens 
this to control domain, daemon in control domain do atoi and math to get 
right memory value). This is very inefficient, especially when we talks 
about bunch of VM per host.

kernel module can do math internally with ints, not with strings (no 
conversion at all) - this will save pretty much time (my calculation is 
about one-two of CPU time per day for every virtualization host with 
about 50-100 active VMs.

The information I needs is amount of 'really free' memory. We calculate 
it as (roughly) as  MemFree+Buffers+Cached+(SwapTotal-SwapFree), and our 
management system trying to keep this value within expected values (f.e. 
within interval 128-256Mb). This allows us to prevent VM's swapping and 
allow VM to push to swap really rare used pages (and their place 
actually used for caching).


On 02.09.2011 23:53, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 02 Sep 2011 19:41:29 +0400, George Shuklin said:
>> Good day.
>>
>> Why si_swapinfo (from include/linux/swap.h) is not marked as
>> EXPORT_SYMBOL_GPL? It's kinda hard to gain information about memory in
>> module.
> Use case?  What information exactly are you trying to get in the module, and
> equally important, why?  More likely, what you *actually* want isn't the
> information, it's a new API (or using an existing one you didn't even know was
> there) :)
>
