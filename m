Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab0HDKrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:47:06 -0400
Received: from mx6.sophos.com ([213.31.172.36]:59629 "EHLO mx6.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932556Ab0HDKrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:47:01 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.35 hangs on early boot in KVM
Date: Wed, 4 Aug 2010 11:46:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Gleb Natapov <gleb@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <201008031028.57263.tvrtko.ursulin@sophos.com> <20100804093623.GE10499@redhat.com> <m1fwyuacjs.fsf@fess.ebiederm.org>
In-Reply-To: <m1fwyuacjs.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Message-ID: <201008041146.56406.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2010 11:46:56,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 04/08/2010 11:46:57,
	Serialize complete at 04/08/2010 11:46:57
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 Aug 2010 11:37:43 Eric W. Biederman wrote:
> Gleb Natapov <gleb@redhat.com> writes:
> > On Wed, Aug 04, 2010 at 10:16:08AM +0100, Tvrtko Ursulin wrote:
> >> Not the tip but 2.6.35 with earlyprintk=ttyS0,115200:
> >>
> >> [    0.000000] Processor #0 (Bootup-CPU)
> >> [    0.000000] I/O APIC #1 Version 17 at 0xFEC00000.
> >> [    0.000000] BUG: unable to handle kernel paging request at ffffb030
> >> [    0.000000] IP: [<c011d136>] native_apic_mem_read+0x16/0x20
> >> [    0.000000] *pde = 00832067 *pte = 00000000
> >
> > Accessing APIC version register before APIC is mapped.
>
> Yep. I see it now.  We have some of the silliest code.  We only
> go down this path for certain revs of Intel cpus, and I double checked
> this change on an AMD cpu which explains why I missed hitting this
> case.
>
> The call path that is new in they bisected commit is:
> MP_ioapic_info()
>   mp_register_ioapic()
>    io_apic_unique_id()
>      io_apic_get_unique_id()
>        get_physical_broadcast()
>          modern_apic()
>            lapic_get_version()
>              apic_read(APIC_LVR)
>
>
> Tvrtko can you test this patch and verify it fixes the kvm booting
> issue?
>
> This patch just maps the lapic early in the mmparse.c just like we
> do in acpi/boot.c when parsing the acpi tables.

Boots fine, thanks!

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
