Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2E3Tno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:43:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab2E3Tnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:43:42 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=QqmzYZ8R8N4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=n8i27M1mAAAA:8 a=JfrnYn6hAAAA:8 a=fKI9wT_O-dN3BeuwhacA:9 a=PUjeQqilurYA:10 a=rXZLD9m7qZoA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338407017.13348.311.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 0/5] Function tracing support for pstore
From: Steven Rostedt <rostedt@goodmis.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Date: Wed, 30 May 2012 15:43:37 -0400
In-Reply-To: <20120526133412.GA18001@lizard>
References: <20120526133412.GA18001@lizard>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-26 at 06:34 -0700, Anton Vorontsov wrote:
> Hi all,
> 

Sorry for the late reply, Monday was US holiday, and I've been working
days on finding (and fixing) a very nasty bug.

> With this support kernel can save functions call chain log into a
> persistent ram buffer that can be decoded and dumped after reboot
> through pstore filesystem. It can be used to determine what function
> was last called before a hang or an unexpected reset (caused by, for
> example, a buggy driver that abuses HW).
> 

Nice!

> Here's a "nano howto", to get the idea:
> 
>  # mount -t debugfs debugfs /sys/kernel/debug/
>  # cd /sys/kernel/debug/tracing
>  # echo persistent > current_tracer
>  # reboot -f
>  [...]
>  # mount -t pstore pstore /mnt/
>  # tail /mnt/ftrace-ramoops
>  0 ffffffff8101ea64  ffffffff8101bcda  native_apic_mem_read <- disconnect_bsp_APIC+0x6a/0xc0
>  0 ffffffff8101ea44  ffffffff8101bcf6  native_apic_mem_write <- disconnect_bsp_APIC+0x86/0xc0
>  0 ffffffff81020084  ffffffff8101a4b5  hpet_disable <- native_machine_shutdown+0x75/0x90
>  0 ffffffff81005f94  ffffffff8101a4bb  iommu_shutdown_noop <- native_machine_shutdown+0x7b/0x90
>  0 ffffffff8101a6a1  ffffffff8101a437  native_machine_emergency_restart <- native_machine_restart+0x37/0x40
>  0 ffffffff811f9876  ffffffff8101a73a  acpi_reboot <- native_machine_emergency_restart+0xaa/0x1e0
>  0 ffffffff8101a514  ffffffff8101a772  mach_reboot_fixups <- native_machine_emergency_restart+0xe2/0x1e0
>  0 ffffffff811d9c54  ffffffff8101a7a0  __const_udelay <- native_machine_emergency_restart+0x110/0x1e0
>  0 ffffffff811d9c34  ffffffff811d9c80  __delay <- __const_udelay+0x30/0x40
>  0 ffffffff811d9d14  ffffffff811d9c3f  delay_tsc <- __delay+0xf/0x20
> 
> Mostly the code comes from trace_persistent.c driver found in the
> Android git tree, written by Colin Cross <ccross@android.com>
> (according to sign-off history). I reworked the driver a little bit,
> and ported it to pstore subsystem.
> 
> The patches depend on a pile of other pstore-related work, so
> if anyone is willing to try the patches, they would rather grab
> the whole git tree:
> 	git://git.infradead.org/users/cbou/linux-pstore.git
> or gitweb:
> 	http://git.infradead.org/users/cbou/linux-pstore.git
> 
> 
> Note that so far I've tried to not change the original idea, but if
> we consider inclusion, there are some open questions:
> 
> 1. Should we merge persistent tracer with normal function tracer,
>    i.e. add some flag that makes function tracer to duplicate the
>    events into pstore (via a callback to pstore)?
> 

What about making it a trace option? That is,
in .../debug/tracing/options, have 'persistent' and when that's
selected, we change to using the persistent buffer. This could be for
both function tracing and event tracing.

I'm currently working on getting 'multi' buffers working. I plan on
presenting it at Linux Plumbers for more feedback. But it will be adding
a lot of hooks that would probably make this rather trivial to
implement.

-- Steve

> 2. If we keep the two separate, should the code live in fs/pstore
>    or kernel/trace?.. I can see valid points for both approaches.
> 
> Thanks,


