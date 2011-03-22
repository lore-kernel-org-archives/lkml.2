Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1CVUrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:47:32 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41280 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab1CVUr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:47:29 -0400
MIME-Version: 1.0
In-Reply-To: <20110301213313.GA6507@albatros>
References: <201102272122.52643.arnd@arndb.de>
	<4D6B6AE7.2050202@msgid.tls.msk.ru>
	<20110228095133.GA4351@albatros>
	<20110228.112349.104067277.davem@davemloft.net>
	<20110301194845.GA3533@albatros>
	<1299010390.2529.30.camel@bwh-desktop>
	<20110301213313.GA6507@albatros>
Date: Tue, 22 Mar 2011 16:47:27 -0400
Message-ID: <AANLkTikr=qfFeaXDkiBbK-4KvKS83LzURrUj4L2TP8_u@mail.gmail.com>
Subject: Re: [PATCH v2] net: don't allow CAP_NET_ADMIN to load non-netdev
 kernel modules
From: Eric Paris <eparis@parisplace.org>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, mjt@tls.msk.ru, arnd@arndb.de,
        mirqus@gmail.com, netdev@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru,
        pekkas@netcore.fi, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, eric.dumazet@gmail.com, therbert@google.com,
        xiaosuo@gmail.com, jesse@nicira.com, kees.cook@canonical.com,
        eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org, Greg KH <greg@kroah.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        LSM List <linux-security-module@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 4:33 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> Since a8f80e8ff94ecba629542d9b4b5f5a8ee3eb565c any process with
> CAP_NET_ADMIN may load any module from /lib/modules/.  This doesn't mean
> that CAP_NET_ADMIN is a superset of CAP_SYS_MODULE as modules are
> limited to /lib/modules/**.  However, CAP_NET_ADMIN capability shouldn't
> allow anybody load any module not related to networking.
>
> This patch restricts an ability of autoloading modules to netdev modules
> with explicit aliases.  This fixes CVE-2011-1019.
>
> Arnd Bergmann suggested to leave untouched the old pre-v2.6.32 behavior
> of loading netdev modules by name (without any prefix) for processes
> with CAP_SYS_MODULE to maintain the compatibility with network scripts
> that use autoloading netdev modules by aliases like "eth0", "wlan0".
>
> Currently there are only three users of the feature in the upstream
> kernel: ipip, ip_gre and sit.

This patch is causing a bit of a problem in Fedora.  The problem lies
mostly in the fact that we, by means of using SELinux, grant very very
few domains CAP_SYS_MODULE (and we record when domains attempt to use
this permission).  Unlike most other distros in which uid==0 is for
all intensive purposes == CAP_FULL_SET and there is no logging of
failures to use capabilities.  What happened is that as soon as we
instituted this change we started getting SELinux denials because lots
of domains (libvirt, udev, iw, NetworkManager) all the sudden started
trying to use CAP_SYS_MODULE.  It took me a minute to make sure this
patch was the problem because I wasn't seeing any printk messages.  I
had to make some changes to the patch to print every time a task got
into the CAP_SYS_MODULE case in order to get an idea what was causing
the problem.  I found on my machine I hit the problem 3 times trying
to load "reg", "wifi0", and "virbr0"    None of these are actual
modules in userspace so the upcall failed.

I'm trying to figure out how I should be dealing with this.

My first idea is changing the capable(CAP_SYS_MODULE) into a
has_capability_noaudit().  Which will not audit the access attempt.
I'm not sure I like that since it uses the read cred, it doesn't set
PF_SUPERPRIV, and it means we could likely miss recording a problem if
a task is doing this intentionally...

The next idea is I guess figuring out what's causing these and fix
them there, but I'm not certain a good way to debug it.  I know from
our audit logs that wpa_supplicant is calling SIOCGIFINDEX which is
causing one of these, libvirt is calling SIOCGIFFLAGS.  I'm not sure
what udev->iw is doing to trigger it's problem.....

If the name in question is not coming from direct userspace request I
guess I need help figuring out what is causing them....

So while this patch might not necessarily be breaking things it
certainly is not regression free and could potentially be breaking
systems with fine grained capabilities controls....

-Eric

>    root@albatros:~# capsh --drop=$(seq -s, 0 11),$(seq -s, 13 34) --
>    root@albatros:~# grep Cap /proc/$$/status
>    CapInh:     0000000000000000
>    CapPrm:     fffffff800001000
>    CapEff:     fffffff800001000
>    CapBnd:     fffffff800001000
>    root@albatros:~# modprobe xfs
>    FATAL: Error inserting xfs
>    (/lib/modules/2.6.38-rc6-00001-g2bf4ca3/kernel/fs/xfs/xfs.ko): Operation not permitted
>    root@albatros:~# lsmod | grep xfs
>    root@albatros:~# ifconfig xfs
>    xfs: error fetching interface information: Device not found
>    root@albatros:~# lsmod | grep xfs
>    root@albatros:~# lsmod | grep sit
>    root@albatros:~# ifconfig sit
>    sit: error fetching interface information: Device not found
>    root@albatros:~# lsmod | grep sit
>    root@albatros:~# ifconfig sit0
>    sit0      Link encap:IPv6-in-IPv4
>              NOARP  MTU:1480  Metric:1
>
>    root@albatros:~# lsmod | grep sit
>    sit                    10457  0
>    tunnel4                 2957  1 sit
>
> For CAP_SYS_MODULE module loading is still relaxed:
>
>    root@albatros:~# grep Cap /proc/$$/status
>    CapInh:     0000000000000000
>    CapPrm:     ffffffffffffffff
>    CapEff:     ffffffffffffffff
>    CapBnd:     ffffffffffffffff
>    root@albatros:~# ifconfig xfs
>    xfs: error fetching interface information: Device not found
>    root@albatros:~# lsmod | grep xfs
>    xfs                   745319  0
>
> Reference: https://lkml.org/lkml/2011/2/24/203
>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  v2 - use pr_err()
>    - don't try to load $name if netdev-$name is loaded
>
>  include/linux/netdevice.h |    3 +++
>  net/core/dev.c            |   12 ++++++++++--
>  net/ipv4/ip_gre.c         |    2 +-
>  net/ipv4/ipip.c           |    2 +-
>  net/ipv6/sit.c            |    2 +-
>  5 files changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index d971346..71caf7a 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2392,6 +2392,9 @@ extern int netdev_notice(const struct net_device *dev, const char *format, ...)
>  extern int netdev_info(const struct net_device *dev, const char *format, ...)
>        __attribute__ ((format (printf, 2, 3)));
>
> +#define MODULE_ALIAS_NETDEV(device) \
> +       MODULE_ALIAS("netdev-" device)
> +
>  #if defined(DEBUG)
>  #define netdev_dbg(__dev, format, args...)                     \
>        netdev_printk(KERN_DEBUG, __dev, format, ##args)
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8ae6631..6561021 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1114,13 +1114,21 @@ EXPORT_SYMBOL(netdev_bonding_change);
>  void dev_load(struct net *net, const char *name)
>  {
>        struct net_device *dev;
> +       int no_module;
>
>        rcu_read_lock();
>        dev = dev_get_by_name_rcu(net, name);
>        rcu_read_unlock();
>
> -       if (!dev && capable(CAP_NET_ADMIN))
> -               request_module("%s", name);
> +       no_module = !dev;
> +       if (no_module && capable(CAP_NET_ADMIN))
> +               no_module = request_module("netdev-%s", name);
> +       if (no_module && capable(CAP_SYS_MODULE)) {
> +               if (!request_module("%s", name))
> +                       pr_err("Loading kernel module for a network device "
> +"with CAP_SYS_MODULE (deprecated).  Use CAP_NET_ADMIN and alias netdev-%s "
> +"instead\n", name);
> +       }
>  }
>  EXPORT_SYMBOL(dev_load);
>
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 6613edf..d1d0e2c 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -1765,4 +1765,4 @@ module_exit(ipgre_fini);
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS_RTNL_LINK("gre");
>  MODULE_ALIAS_RTNL_LINK("gretap");
> -MODULE_ALIAS("gre0");
> +MODULE_ALIAS_NETDEV("gre0");
> diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
> index 988f52f..a5f58e7 100644
> --- a/net/ipv4/ipip.c
> +++ b/net/ipv4/ipip.c
> @@ -913,4 +913,4 @@ static void __exit ipip_fini(void)
>  module_init(ipip_init);
>  module_exit(ipip_fini);
>  MODULE_LICENSE("GPL");
> -MODULE_ALIAS("tunl0");
> +MODULE_ALIAS_NETDEV("tunl0");
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index 8ce38f1..d2c16e1 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -1290,4 +1290,4 @@ static int __init sit_init(void)
>  module_init(sit_init);
>  module_exit(sit_cleanup);
>  MODULE_LICENSE("GPL");
> -MODULE_ALIAS("sit0");
> +MODULE_ALIAS_NETDEV("sit0");
> --
> 1.7.0.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
