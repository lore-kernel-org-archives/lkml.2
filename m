Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2K1VLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 16:11:05 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:37389 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932270Ab2K1VLC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 16:11:02 -0500
X-Greylist: delayed 1013 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 16:11:02 EST
Message-ID: <50B679E1.5070205@shipmail.org>
Date: Wed, 28 Nov 2012 21:53:53 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com> <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com> <50B46336.8030605@nvidia.com> <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com> <50B476E1.4070403@nvidia.com> <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com> <50B47DA8.60609@nvidia.com>	<1354011776.1479.31.camel@tellur> <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de> <50B4A483.8030305@nvidia.com> <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com> <50B60EFF.1050703@nvidia.com> <1354109602.1479.66.camel@tellur>
In-Reply-To: <1354109602.1479.66.camel@tellur>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 02:33 PM, Lucas Stach wrote:
> Am Mittwoch, den 28.11.2012, 15:17 +0200 schrieb Terje Bergström:
>> On 28.11.2012 01:00, Dave Airlie wrote:
>>> We  generally aim for the first, to stop the gpu from reading/writing
>>> any memory it hasn't been granted access to,
>>> the second is nice to have though, but really requires a GPU with VM
>>> to implement properly.
>> I wonder if we should aim at root only access on Tegra20, and force
>> IOMMU on Tegra30 and fix the remaining issues we have with IOMMU. The
>> firewall turns out to be more complicated than I wished.
>>
>> Biggest problem is that we aim at zero-copy for everything possible,
>> including command streams. Kernel gets a handle to a command stream, but
>> the command stream is allocated by the user space process. So the user
>> space can tamper with the stream once it's been written to the host1x 2D
>> channel.
>>
> So this is obviously wrong. Userspace has to allocate a pushbuffer from
> the kernel just as every other buffer, then map it into it's own address
> space to push in commands. At submit time of the pushbuf kernel has to
> make sure that userspace is not able to access the memory any more, i.e.
> kernel shoots down the vma or pagetable of the vma.

To me this sounds very expensive. Zapping the page table requires a CPU 
TLB flush
on all cores that have touched the buffer, not to mention the kernel calls
required to set up the page table once the buffer is reused.

If this usage scheme then is combined with a command verifier or 
"firewall" that
reads from a *write-combined* pushbuffer performance will be bad. Really 
bad.

In such situations I think one should consider copy-from-user while 
validating, and
let user-space set up the command buffer in malloced memory.

/Thomas



