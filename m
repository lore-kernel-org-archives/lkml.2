Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0KIJxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:53:25 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:15785 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779Ab0KIJxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:53:24 -0500
Message-ID: <4CD91A07.1060308@vmware.com>
Date: Tue, 09 Nov 2010 10:53:11 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Jerome Glisse <j.glisse@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        Michel Danzer <daenzer@vmware.com>
Subject: Re: Radeon RS780 - BUG: unable to handle kernel NULL pointer dereference
References: <20101108170221.GA1602@arch.trippelsdorf.de> <20101108170737.GA1617@arch.trippelsdorf.de> <20101108184301.GA1614@arch.trippelsdorf.de> <20101108190258.GA1623@arch.trippelsdorf.de> <AANLkTi=fo3rnBp8Fs6H+ivP6R+x=QDzBLyi+DmT-LNHV@mail.gmail.com> <4CD879BC.5060008@vmware.com> <20101109092920.GA1542@arch.trippelsdorf.de>
In-Reply-To: <20101109092920.GA1542@arch.trippelsdorf.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 10:29 AM, Markus Trippelsdorf wrote:
> On Mon, Nov 08, 2010 at 11:29:16PM +0100, Thomas Hellstrom wrote:
>    
>> On 11/08/2010 09:53 PM, Jerome Glisse wrote:
>>      
>>> On Mon, Nov 8, 2010 at 2:02 PM, Markus Trippelsdorf
>>> <markus@trippelsdorf.de>   wrote:
>>>        
>>>> On Mon, Nov 08, 2010 at 07:43:02PM +0100, Markus Trippelsdorf wrote:
>>>>          
>>>>> On Mon, Nov 08, 2010 at 06:07:37PM +0100, Markus Trippelsdorf wrote:
>>>>>            
>>>>>> On Mon, Nov 08, 2010 at 06:02:21PM +0100, Markus Trippelsdorf wrote:
>>>>>>              
>>>>>>> I can trigger a kernel crash on my system by simply loading this png
>>>>>>> image with firefox:
>>>>>>> http://mediaarchive.cern.ch/MediaArchive/Photo/Public/2010/1011251/1011251_01/1011251_01-A4-at-144-dpi.jpg
>>>>>>>                
>>>>>> Sorry the above link is wrong, this is the right one (that triggers the
>>>>>> crash):
>>>>>> http://cdsweb.cern.ch/record/1305179/files/HI-150431-630470-huge.png
>>>>>>              
>>>>> I triggered it a few more times and took the attached picture.
>>>>> It points to the BUG() call at drivers/gpu/drm/ttm/ttm_bo.c:1628 .
>>>>> (Sorry for the bad picture quality)
>>>>>            
>>>> And here the same BUG in plaintext (should be a bit easier to read):
>>>>
>>>> Nov  8 19:28:23 arch kernel: ------------[ cut here ]------------
>>>> Nov  8 19:28:23 arch kernel: kernel BUG at drivers/gpu/drm/ttm/ttm_bo.c:1628!
>>>>
>>>>          
>>> Thomas this bug seems to point to a case where we endup trying adding
>>> an entry to
>>> same offset in the rb tree for addr_space_mm. After reviewing
>>> carefully the locking
>>> around the rb tree modification&   addr_space_mm i am fairly confident
>>> that no race can
>>> occur. Would you have any idea on what might go wrong here ? I guess i would
>>> ultimately need to dump mm&   rb tree state when BUG get trigger to try
>>> to understand
>>> states of things.
>>>        
>> I agree there shouldn't be a race in this case.
>> The locking around these operations is simple and straightforward.
>>
>> So this IMHO should either be a memory corruption or a bug in the
>> range manager. I've never seen this BUG trigger before. Dumping mm /
>> rb tree contents or bisecting should probably find the culprit.
>>      
> OK I've found the buggy commit by bisection:
>
> e376573f7267390f4e1bdc552564b6fb913bce76 is the first bad commit
> commit e376573f7267390f4e1bdc552564b6fb913bce76
> Author: Michel Dänzer<daenzer@vmware.com>
> Date:   Thu Jul 8 12:43:28 2010 +1000
>
>      drm/radeon: fall back to GTT if bo creation/validation in VRAM fails.
>
>      This fixes a problem where on low VRAM cards we'd run out of space for validation.
>
>      [airlied: Tested on my M7, Thinkpad T42, compiz works with no problems.]
>
>      Signed-off-by: Michel Dänzer<daenzer@vmware.com>
>      Cc: stable@kernel.org
>      Signed-off-by: Dave Airlie<airlied@redhat.com>
>
> Please note that this is an old commit from 2.6.36-rc. When I revert it the
> kernel no longer crashes. Instead I see the following in my dmesg:
>
>    

Hmm, so this sounds like something in the Radeon eviction error path is 
causing corruption.
I had a similar problem with vmwgfx, when I tried to unref a BO _after_ 
ttm_bo_init() failed.
ttm_bo_init() is really supposed to call unref itself for various 
reasons,  so calling unref() or kfree() after a failed ttm_bo_init() 
will cause corruption.

In any case, the error below also suggests something is a bit fragile in 
the Radeon driver:

First, an accelerated eviction may fail, like in the message below, but 
then there must always be a backup plan, like unaccelerated eviction to 
system. On BO creation, there are a number of placement strategies, but 
if all else fails, it should be possible to initially place the BO in 
system memory.

Second, If bo validation fails during a command submission, due to 
insufficient VRAM / TT, then the driver should retry the complete 
validation cycle after first blocking all other validators and then 
evicting everything not pinned, to avoid failures due to fragmentation.

/Thomas


> [TTM] Failed to find memory space for buffer 0xffff880113e10e48 eviction.
> [TTM] No space for ffff880113e10e48 (25650 pages, 102600K, 100M)
> [TTM]   placement[0]=0x00070002 (1)
> [TTM]     has_type: 1
> [TTM]     use_type: 1
> [TTM]     flags: 0x0000000A
> [TTM]     gpu_offset: 0xA0000000
> [TTM]     size: 131072
> [TTM]     available_caching: 0x00070000
> [TTM]     default_caching: 0x00010000
> [TTM]  0x00000000-0x00000001:        1: used
> [TTM]  0x00000001-0x00000011:       16: used
> [TTM]  0x00000011-0x00000111:      256: used
> [TTM]  0x00000111-0x00000211:      256: used
> [TTM]  0x00000211-0x00000248:       55: free
> [TTM]  0x00000248-0x0000024c:        4: used
> [TTM]  0x0000024c-0x00001976:     5930: free
> [TTM]  0x00001976-0x000021aa:     2100: used
> [TTM]  0x000021aa-0x0000285f:     1717: free
> [TTM]  0x0000285f-0x00002860:        1: used
> [TTM]  0x00002860-0x00002873:       19: free
> [TTM]  0x00002873-0x000029b3:      320: used
> [TTM]  0x000029b3-0x00020000:   120397: free
> [TTM]  total: 131072, used 2954 free 128118
> [drm:radeon_cs_ioctl] *ERROR* Failed to parse relocation -12!
> radeon 0000:01:05.0: object_init failed for (117555200, 0x00000004)
> [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (117555200, 4, 4096, -12)
> radeon 0000:01:05.0: object_init failed for (117555200, 0x00000004)
> [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (117555200, 4, 4096, -12)
> radeon 0000:01:05.0: object_init failed for (117555200, 0x00000004)
> [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (117555200, 4, 4096, -12)
> radeon 0000:01:05.0: object_init failed for (117555200, 0x00000004)
> [drm:radeon_gem_object_create] *ERROR* Failed to allocate GEM object (117555200, 4, 4096, -12)
> radeon 0000:01:05.0: object_init failed for (117555200, 0x00000004)
> ...
>
> And the following in the xorg log buffer:
>
> Failed to alloc memory
> Failed to allocat:
>     size:     : 117555200 bytes
>     alignment : 0 bytes
>     domains   : 4
> ...
>
>    

