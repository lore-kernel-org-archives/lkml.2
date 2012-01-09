Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2AIATI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 19:19:08 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37241 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2AIATD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 19:19:03 -0500
MIME-Version: 1.0
In-Reply-To: <1326055714.13595.309.camel@deadeye>
References: <1326055714.13595.309.camel@deadeye>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 8 Jan 2012 16:18:41 -0800
X-Google-Sender-Auth: Ypo5PW4oKH7ILB1rqZFl8TVYDXM
Message-ID: <CA+55aFwwnJPpVY++Vgr6p3s47YjdYWV3sgLZzvCtiJp6DEu78Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] topology: Check for missing CPU devices
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        linux-m68k@vger.kernel.org, debian-68k@lists.debian.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, both of the patches look sane to me, but it would really be nice
to hear from somebody with the actual affected architectures, and get
a tested-by.

Testing it on hacked-up x86 sounds fine, but doesn't quite have the
same kind of "yes, this fixes the actual problem" feel to it.

Also, can you clarify: does the second patch make the first patch just
an "irrelevant safety net", or are there possible callers of
topology_add_dev() that could cause problems? I'm just wondering
whether maybe the safety net ends up then possibly hiding some future
bug where we (once more) don't register a cpu and then never really
notice?

Or am I just being difficult?

                     Linus

On Sun, Jan 8, 2012 at 12:48 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> Commit ccbc60d3e19a1b6ae66ca0d89b3da02dde62088b ('topology: Provide
> CPU topology in sysfs in !SMP configurations') causes a crash at boot
> on a several architectures.  The topology sysfs code assumes that
> there is a CPU device for each online CPU whereas some architectures
> that do not support SMP or cpufreq do not register any CPU devices.
> Check for this before trying to use a device.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/base/topology.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/topology.c b/drivers/base/topology.c
> index ae989c5..4467c85 100644
> --- a/drivers/base/topology.c
> +++ b/drivers/base/topology.c
> @@ -147,6 +147,8 @@ static int __cpuinit topology_add_dev(unsigned int cpu)
>  {
>        struct device *dev = get_cpu_device(cpu);
>
> +       if (!dev)
> +               return -ENODEV;
>        return sysfs_create_group(&dev->kobj, &topology_attr_group);
>  }
>
> @@ -154,7 +156,8 @@ static void __cpuinit topology_remove_dev(unsigned int cpu)
>  {
>        struct device *dev = get_cpu_device(cpu);
>
> -       sysfs_remove_group(&dev->kobj, &topology_attr_group);
> +       if (dev)
> +               sysfs_remove_group(&dev->kobj, &topology_attr_group);
>  }
>
>  static int __cpuinit topology_cpu_callback(struct notifier_block *nfb,
> --
> 1.7.8.2
>
>
>
