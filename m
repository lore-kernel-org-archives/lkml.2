Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab0GDLyU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 07:54:20 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:36185 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425Ab0GDLyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 07:54:18 -0400
Message-ID: <4C307668.40002@tilera.com>
Date: Sun, 4 Jul 2010 07:54:16 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
       <arnd@arndb.de>
Subject: Re: [PATCH] arch/tile: updates to hardwall code from community feedback.
References: <201007030217.o632HoK9004030@farm-0002.internal.tilera.com> <20100704035759.GA5888@linux-sh.org>
In-Reply-To: <20100704035759.GA5888@linux-sh.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/3/2010 11:57 PM, Paul Mundt wrote:
> On Fri, Jul 02, 2010 at 11:45:18AM -0400, Chris Metcalf wrote:
>   
>>  #define for_each_hardwall_task_safe(pos, n, head) \
>> -	hardwall_for_each_entry_safe(pos, n, head, thread.hardwall_list)
>> +	list_for_each_entry_safe(pos, n, head, thread.hardwall_list)
>>  
>>     
> If you've killed off the rest of the wrappers due to them not really
> having to do anything special, you could do the same for this one, too.
>   

Good point, thanks.  Done.

>>  static struct hardwall_info *hardwall_create(
>> -	size_t size, const unsigned long __user *bits)
>> +	size_t size, const unsigned char __user *bits)
>>  {
>> [...]
>>  
>>     
> Does it even make any sense to accept > sizeof(struct cpumask) ? Your
> case below obviously handles this by making sure the rest of the bits are
> zeroed, but that still seems a bit excessive. If anything, the
> sizeof(struct cpumask) should be your worst case (or just rejected out of
> hand), and you could use cpumask_size() for everything else.
>   

Yes, it does make sense; see get_nodes() in mm/mempolicy.c for a similar
API philosophy.  The idea is that you don't want to tie userspace code
to the particular NR_CPUS that you happened to build your kernel with. 
So you let userspace use any reasonable value for its bitmask, and as
long as it's passing zeroes for the >NR_CPUS positions, that's OK.

cpumask_parse_user() won't help here, since we're not parsing an ASCII
string input.  The main flow is just a copy_from_user() for the bits in
the mask, then an optional memset() if the user specified fewer than
NR_CPUS cpus, or a scan to check for set bits if the user specified more
than NR_CPUS cpus.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

