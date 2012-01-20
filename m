Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2ATXIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:08:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326Ab2ATXIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:08:37 -0500
Date: Fri, 20 Jan 2012 17:08:31 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: radeon issues on MacBook Pro 8,2
Message-ID: <20120120230831.GA2292@ubuntu-macmini>
Mail-Followup-To: Alex Deucher <alexdeucher@gmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <20120119171808.GB23144@ubuntu-macmini>
 <CADnq5_MiLE0XSpbrd66003DVxdR9c4MgQav3BD+bWtrKvbf+7Q@mail.gmail.com>
 <20120119205317.GC23144@ubuntu-macmini>
 <20120120155318.GA8162@ubuntu-macmini>
 <CADnq5_NNpwsPoEP0_fzSJ9LQKfaHPJx90yObXKYHO39xLWM6sQ@mail.gmail.com>
 <20120120211214.GC8162@ubuntu-macmini>
 <CADnq5_NcZacne-VH-N7FQ5GQo8EbWNgi7WjeHxnJHciyaSeBvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_NcZacne-VH-N7FQ5GQo8EbWNgi7WjeHxnJHciyaSeBvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 04:39:31PM -0500, Alex Deucher wrote:
> On Fri, Jan 20, 2012 at 4:12 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > On Fri, Jan 20, 2012 at 02:38:37PM -0500, Alex Deucher wrote:
> >> On Fri, Jan 20, 2012 at 10:53 AM, Seth Forshee
> >> <seth.forshee@canonical.com> wrote:
> >> > On Thu, Jan 19, 2012 at 02:53:17PM -0600, Seth Forshee wrote:
> >> >> > >  2. Occasional long delays when suspending. When this happens I see
> >> >> > >    messages like following in dmesg:
> >> >> > >
> >> >> > >      [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs aborting
> >> >> > >      [drm:atom_execute_table_locked] *ERROR* atombios stuck executing D44E (len 62, WS 0, PS 0) @ 0xD46A
> >> >> > >
> >> >> > >    Sometimes one of suspend or resume hangs completely, but I can't
> >> >> > >    tell which and am not sure whether or not it's related. I'm also
> >> >> > >    testing a Mac Mini with the exact same card which does not seem to
> >> >> > >    suffer from this issue.
> >> >> > >
> >> >> > >    I ran a bisections that identified f8d0edd (drm/radeon/kms: improve
> >> >> > >    DP detect logic) as introducing problems with suspend, and reverting
> >> >> > >    this patch on top of 3.2.1 does seem to eliminate both issues.
> >> >> > >
> >> >> >
> >> >> > That patch doesn't really affect the modesetting paths directly; it
> >> >> > looks like a red herring to me.
> >> >>
> >> >> Perhaps. I just started a run of 200 s3 cycles with the patch reverted
> >> >> to see if I can reproduce the issues. I can usually trigger the problem
> >> >> with 15 or fewer s3 cycles.
> >> >
> >> > The machine completed 200 s3 cycles with the patch reverted without long
> >> > delays, hangs, or any atombios error messages. Without reverting it
> >> > doesn't get through many at all before experiencing the errors and long
> >> > delays or hangs.
> >> >
> >> > I added a printout of the connector status resulting from the logic that
> >> > was changed by f8d0edd. With the logic prior to this commit it
> >> > consistently returns the status as disconnected, which is correct as I
> >> > have nothing connected. But with the improved logic the status is
> >> > sometimes reported as connected, and these coincide with the atombios
> >> > errors.
> >> >
> >>
> >> Do any of the disconnected displayport connectors get misdetected as
> >> connected during normal operation or does it only happen during
> >> suspend/resume?
> >
> > So far I've only seen them during suspend/resume.
> 
> Can you track down who is calling the connector->detect() callbacks
> during suspend and resume?

I got two different stack traces, see below.

And to slightly amend my statement above, I'm only seeing the wrong
status returned on the suspend side of things. The status during resume
always seems to be correct.

 Pid: 49, comm: kworker/0:2 Tainted: G         C O 3.2.0-10-generic #17-Ubuntu
 Call Trace:
  [<ffffffffa03f5e1e>] radeon_dp_detect+0x1de/0x230 [radeon]
  [<ffffffffa014ac6d>] output_poll_execute+0xbd/0x1a0 [drm_kms_helper]
  [<ffffffffa014abb0>] ? drm_helper_mode_fill_fb_struct+0x30/0x30 [drm_kms_helper]
  [<ffffffff81083dca>] process_one_work+0x11a/0x480
  [<ffffffff81084b74>] worker_thread+0x164/0x370
  [<ffffffff81084a10>] ? manage_workers.isra.30+0x130/0x130
  [<ffffffff810893cc>] kthread+0x8c/0xa0
  [<ffffffff81660674>] kernel_thread_helper+0x4/0x10
  [<ffffffff81089340>] ? flush_kthread_worker+0xa0/0xa0
  [<ffffffff81660670>] ? gs_change+0x13/0x13

 Pid: 49, comm: kworker/0:2 Tainted: G         C O 3.2.0-10-generic #17-Ubuntu
 Call Trace:
  [<ffffffffa03f5e1e>] radeon_dp_detect+0x1de/0x230 [radeon]
  [<ffffffffa014b6b3>] drm_helper_probe_single_connector_modes+0x2c3/0x380 [drm_kms_helper]
  [<ffffffffa0149d42>] drm_fb_helper_hotplug_event+0xf2/0x150 [drm_kms_helper]
  [<ffffffffa03fe8d5>] radeon_fb_output_poll_changed+0x15/0x20 [radeon]
  [<ffffffffa03f7b65>] radeon_output_poll_changed+0x15/0x20 [radeon]
  [<ffffffffa014ad40>] output_poll_execute+0x190/0x1a0 [drm_kms_helper]
  [<ffffffffa014abb0>] ? drm_helper_mode_fill_fb_struct+0x30/0x30 [drm_kms_helper]
  [<ffffffff81083dca>] process_one_work+0x11a/0x480
  [<ffffffff81084b74>] worker_thread+0x164/0x370
  [<ffffffff81084a10>] ? manage_workers.isra.30+0x130/0x130
  [<ffffffff810893cc>] kthread+0x8c/0xa0
  [<ffffffff81660674>] kernel_thread_helper+0x4/0x10
  [<ffffffff81089340>] ? flush_kthread_worker+0xa0/0xa0
  [<ffffffff81660670>] ? gs_change+0x13/0x13

