Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab0DFVqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:46:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48260 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab0DFVpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=X3etH5XPRxSRzDYtHRoaGNCvLy0Ul+h44g3mA7unhIbFc3eDgFh3DMZTMuEZmItvvU
         BlvBDfTFvSPfk3nn5+4X5yDYuwVfvoieh++86s1L4ja6tl3dLMsu/NEflEHU3hi2Jyyj
         Dub3DG+L8/x44Dn1/hWTVQLBFKAXquOLVK7qI=
MIME-Version: 1.0
In-Reply-To: <20100406211315.GJ3029@redhat.com>
References: <20100403012820.229410717@sous-sol.org>
	 <m1vdc8juju.fsf@fess.ebiederm.org> <4BB83EAE.5090609@bwalle.de>
	 <20100404085338.GU24846@8bytes.org> <m17hond01n.fsf@fess.ebiederm.org>
	 <20100404100101.GW24846@8bytes.org>
	 <20100406174257.GG29241@sequoia.sous-sol.org>
	 <20100406175106.GH28166@amd.com> <20100406203956.GI3029@redhat.com>
	 <20100406211315.GJ3029@redhat.com>
Date: Tue, 6 Apr 2010 14:45:51 -0700
X-Google-Sender-Auth: 2964eaf405b03aca
Message-ID: <z2w86802c441004061445q5a05832fmaece2723436f803f@mail.gmail.com>
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Chris Wright <chrisw@sous-sol.org>,
       Joerg Roedel <joro@8bytes.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernhard Walle <bernhard@bwalle.de>, nhorman@redhat.com,
       nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 2:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Apr 06, 2010 at 04:39:56PM -0400, Vivek Goyal wrote:
>> On Tue, Apr 06, 2010 at 07:51:06PM +0200, Joerg Roedel wrote:
>> > On Tue, Apr 06, 2010 at 10:42:57AM -0700, Chris Wright wrote:
>> > > * Joerg Roedel (joro@8bytes.org) wrote:
>> > > > On Sun, Apr 04, 2010 at 02:44:36AM -0700, Eric W. Biederman wrote:
>> > > > > Joerg Roedel <joro@8bytes.org> writes:
>> > > > >
>> > > > > > On Sun, Apr 04, 2010 at 09:24:30AM +0200, Bernhard Walle wrote:
>> > > > > >> Am 03.04.10 19:49, schrieb Eric W. Biederman:
>> > > > > >> > Not a problem.  We require a lot of things of the kdump kernel,
>> > > > > >> > and it is immediately apparent in a basic sanity test.
>> > > > > >>
>> > > > > >> Also, in most cases (for example: distribution kernels), the kdump
>> > > > > >> kernel nowadays is identical to the running kernel. So, if the running
>> > > > > >> kernel has IOMMU support, the kdump kernel also has.
>> > > > > >
>> > > > > > Yes, I know. But is that a requirement for kexec?
>> > > > >
>> > > > > For normal kexec no.  That path is expected to do a clean hardware
>> > > > > shutdown.
>> > > > >
>> > > > > For kexec on panic aka kdump the requirement is that your your crash
>> > > > > kernel be able to initialize your hardware from any state it can be
>> > > > > put in.
>> > > >
>> > > > Ok, if you show me where this is documented for everybody then I am
>> > > > probably convinced :-)
>> > > > We should fixup the gart initialization anyway.
>> > >
>> > > So, you planning to pull in all 4 patches then?
>> >
>> > Yes, I will apply them tomorrow and write a fix for the GART issue this
>> > may introduce.
>> >
>>
>> Hi Joerg,
>>
>> Going through the old mail thread, I think the commit you pointed to was
>> primarily introduced to solve kexec + GART issue and not necessarily kdump
>> issue.
>>
>> In fact disabling IOMMU patch was introduced by you.
>>
>> Author: Joerg Roedel <joerg.roedel@amd.com>
>> Date:   Tue Jun 9 17:56:09 2009 +0200
>>
>>     x86: disable IOMMUs on kernel crash
>>
>>     If the IOMMUs are still enabled when the kexec kernel boots access to
>>     the disk is not possible. This is bad for tools like kdump or anything
>>     else which wants to use PCI devices.
>>
>>     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
>>
>> I am assuming you introduced this patch because you faced issues with
>> amd-iommu and not GART.
>>
>> So basically GART should have been working with kdump even before you
>> introduced disabling iommu patch in kdump path.
>
> Looking at following commit, we were still not shutting down GART and
> fixing issues like second kernel accessing the GART aperture set by first
> kernel.
>
> commit aaf230424204864e2833dcc1da23e2cb0b9f39cd
> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
> Date:   Wed Jan 30 13:33:09 2008 +0100
>
>    x86: disable the GART early, 64-bit
>
>    For K8 system: 4G RAM with memory hole remapping enabled, or more than
>    4G RAM installed.
>
> So I guess it should be fine to not shutdown GART in crashing kernel and
> then look at the fresh issues which crop up and figure out how to fix
> those.

not sure if it is related:

for crashing kernel, it could do early_memtest to check if some device
are still do dma operation.

When I use kexec to start second kernel, if enable the early_memtest
in second kernel, it will find some pages RAM are BAD,
and it will mark them and not use them.  memtest=1 should be good enough.
Fresh restart will not report there is any BAD ram in the same system.

YH
