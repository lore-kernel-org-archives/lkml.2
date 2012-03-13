Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174Ab2CMJSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:18:38 -0400
Received: from node6.gecad.com ([193.230.245.6]:56723 "EHLO node6.gecad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760013Ab2CMJSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:18:35 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2012 05:18:35 EDT
Message-ID: <4F5F0FB6.1010101@avangate.com>
Date: Tue, 13 Mar 2012 11:13:27 +0200
From: Valentin Avram <valentin.avram@avangate.com>
Reply-To: Valentin AVRAM <valentin.avram@avangate.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120305 Thunderbird/10.0.1
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <eparis@redhat.com>
Subject: BUG in fsnotify_mark on 3.2.9
References: <4ED3C87D.5010400@avangate.com>
In-Reply-To: <4ED3C87D.5010400@avangate.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

A few months ago i sent the email below to this list, but since it was 
about old kernel versions nobody probably had any spare time to look 
into it.

However, the problem still persists in linux-3.2.9 with audit 2.1.3.

More information at:

https://bugs.gentoo.org/show_bug.cgi?id=389405
https://www.redhat.com/archives/linux-audit/2012-January/msg00057.html
https://www.redhat.com/archives/linux-audit/2012-February/msg00007.html
https://www.redhat.com/archives/linux-audit/2012-March/msg00004.html

I also opened a bug at bugzilla.kernel.org, however i mistakenly set it 
to Other/Other instead of FileSystem/Other (FileSystem/VFS). If anybody 
with the necessary privileges is reading this, please change the 
Product/Component accordingly.

https://bugzilla.kernel.org/show_bug.cgi?id=42882

At this moment i can't tell if the bug is in the kernel's audit support 
or in the fsnotify_mark kernel thread. The BUG in 3.2.9 is the following:

kernel: [  301.240011] BUG: unable to handle kernel NULL pointer 
dereference at   (null)
kernel: [  301.240305] IP: [<c1238dd0>] __list_del_entry+0x20/0xe0
kernel: [  301.240481] *pdpt = 0000000000000000 *pde = f000ddc8f000ddc8
kernel: [  301.240698] Oops: 0000 [#1] SMP
kernel: [  301.240910]
kernel: [  301.241030] Pid: 642, comm: fsnotify_mark Not tainted 
3.2.9-drbd-version3 #1 Dell Inc. PowerEdge 2950/0CX396
kernel: [  301.241370] EIP: 0060:[<c1238dd0>] EFLAGS: 00010287 CPU: 6
kernel: [  301.241498] EIP is at __list_del_entry+0x20/0xe0
kernel: [  301.241623] EAX: f4fae544 EBX: f47cffa4 ECX: ffffffff EDX: 
00000000
kernel: [  301.241751] ESI: f4fae544 EDI: f4fae508 EBP: f47cff7c ESP: 
f47cff64
kernel: [  301.241879]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
kernel: [  301.242005] Process fsnotify_mark (pid: 642, ti=f47ce000 
task=f4f47c00 task.ti=f47ce000)
kernel: [  301.242207] Stack:
kernel: [  301.242327]  c10813c0 f47cffa4 f4f47c00 f4e70888 f47cff7c 
f47cffa4 f47cffb8 c10f6976
kernel: [  301.242882]  ffffffc3 f4f47c00 f4f47c00 00000000 f4f47c00 
c10530c0 f47cff9c f47cff9c
kernel: [  301.243438]  f4fae544 f4fae544 f4c47f58 00000000 c10f68f0 
f47cffe4 c1052834 00000000
kernel: [  301.243995] Call Trace:
kernel: [  301.244119]  [<c10813c0>] ? rcu_check_callbacks+0x110/0x110
kernel: [  301.244248]  [<c10f6976>] fsnotify_mark_destroy+0x86/0x120
kernel: [  301.244377]  [<c10530c0>] ? abort_exclusive_wait+0x80/0x80
kernel: [  301.244504]  [<c10f68f0>] ? fsnotify_put_mark+0x30/0x30
kernel: [  301.244631]  [<c1052834>] kthread+0x74/0x80
kernel: [  301.244756]  [<c10527c0>] ? kthread_flush_work_fn+0x10/0x10
kernel: [  301.244885]  [<c1582ab6>] kernel_thread_helper+0x6/0xd
kernel: [  301.245011] Code: 55 f4 8b 45 f8 e9 75 ff ff ff 90 55 89 e5 
53 83 ec 14 8b 08 8b 50 04 81 f9 00 01 10 00 74 24 81 fa 00 02 20 00 0f 
84 8e 00 00 00 <8b> 1a 39 d8 75 62 8b 59 04 39 d8 75 35 89 51 04 89 0a 
83 c4 14
kernel: [  301.248195] EIP: [<c1238dd0>] __list_del_entry+0x20/0xe0 
SS:ESP 0068:f47cff64
kernel: [  301.248414] CR2: 0000000000000000
kernel: [  301.248538] ---[ end trace 15082dbfb353f84c ]---

After this Oops, the kernel keeps logging "list_add corruption" warnings 
on the following 2 comms:
Pid: XXXXX, comm: auditctl Tainted: G      D W    3.2.9-drbd-version3 #1
and
Pid: XXXXX, comm: audit_prune_tre Tainted: G      D W    
3.2.9-drbd-version3 #1

The issue is very easy to reproduce:
1. compile 3.2.9 with the config attached to the bugzilla.kernel.org bug 
or from the auditd mailing list.
2. compile auditd without support for ldap or prelude
3. boot the compiled kernel
4. set the following rules in /etc/audit/audit.rules

# First rule - delete all
-D

-w /etc/ -p wa -k etc-directory
-w /sbin/ -p wa -k sbin-directory
-w /bin/ -p wa -k bin-directory
-w /usr/sbin/ -p wa -k usr-sbin-directory
-w /usr/bin/ -p wa -k usr-bin-directory
### IF EXISTS ### -a exit,never -F dir=/lib/rc -k skip-lib-rc
-w /lib/ -p wa -k lib-directory
-w /usr/lib/ -p wa -k usr-lib-directory

### OR THE FOLLOWING EQUIVALENT
### IF EXISTS ### -a exit,never -F dir=/lib/rc -k skip-lib-rc
### -a exit,always -F dir=/etc/ -F perm=wa -k etc-directory
### -a exit,always -F dir=/sbin/ -F perm=wa -k sbin-directory
### -a exit,always -F dir=/bin/ -F perm=wa -k bin-directory
### -a exit,always -F dir=/usr/sbin/ -F perm=wa -k usr-sbin-directory
### -a exit,always -F dir=/usr/bin/ -F perm=wa -k usr-bin-directory
### -a exit,always -F dir=/lib/ -F perm=wa -k lib-directory
### -a exit,always -F dir=/usr/lib/ -F perm=wa -k usr-lib-directory

# Increase the buffers to survive stress events
-b 8192

5. from a shell, run this: while :; do /etc/init.d/auditd start ; sleep 
5 ; /etc/init.d/auditd stop ; sleep 5 ; done

In less than 5 minutes, the Oops happens. After a reboot and the 
procedure, the new oops is almost identical to the one before, so it's 
very reproductible.

After the oops, on nearly every auditd restart the "list_add corruption" 
warnings are logged.

This is the latest oops i got (after yesterday's reboot):
2012-03-12T19:02:47.247814+02:00 quick158 kernel: [  209.860011] BUG: 
unable to handle kernel NULL pointer dereference at   (null)
2012-03-12T19:02:47.247837+02:00 quick158 kernel: [  209.860307] IP: 
[<c1238dd0>] __list_del_entry+0x20/0xe0
2012-03-12T19:02:47.247852+02:00 quick158 kernel: [  209.860485] *pdpt = 
0000000000000000 *pde = f000ddc8f000ddc8
2012-03-12T19:02:47.247855+02:00 quick158 kernel: [  209.860703] Oops: 
0000 [#1] SMP
2012-03-12T19:02:47.247857+02:00 quick158 kernel: [  209.860916]
2012-03-12T19:02:47.247860+02:00 quick158 kernel: [  209.861038] Pid: 
642, comm: fsnotify_mark Not tainted 3.2.9-drbd-version3 #1 Dell Inc. 
PowerEdge 2950/0CX396
2012-03-12T19:02:47.247875+02:00 quick158 kernel: [  209.861381] EIP: 
0060:[<c1238dd0>] EFLAGS: 00010287 CPU: 5
2012-03-12T19:02:47.247878+02:00 quick158 kernel: [  209.861509] EIP is 
at __list_del_entry+0x20/0xe0
2012-03-12T19:02:47.247881+02:00 quick158 kernel: [  209.861635] EAX: 
f4daf544 EBX: f47d3fa4 ECX: ffffffff EDX: 00000000
2012-03-12T19:02:47.247883+02:00 quick158 kernel: [  209.861764] ESI: 
f4daf544 EDI: f4daf508 EBP: f47d3f7c ESP: f47d3f64
2012-03-12T19:02:47.247885+02:00 quick158 kernel: [  209.861892]  DS: 
007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
2012-03-12T19:02:47.247889+02:00 quick158 kernel: [  209.862020] Process 
fsnotify_mark (pid: 642, ti=f47d2000 task=f4f47c00 task.ti=f47d2000)
2012-03-12T19:02:47.247891+02:00 quick158 kernel: [  209.862224] Stack:
2012-03-12T19:02:47.247893+02:00 quick158 kernel: [  209.862344]  
c10813c0 f47d3fa4 f4f47c00 f4e59308 f47d3f7c f47d3fa4 f47d3fb8 c10f6976
2012-03-12T19:02:47.247896+02:00 quick158 kernel: [  209.862904]  
ffffffc3 f4f47c00 f4f47c00 00000000 f4f47c00 c10530c0 f47d3f9c f47d3f9c
2012-03-12T19:02:47.247898+02:00 quick158 kernel: [  209.863464]  
f4daf544 f4daf544 f4c47f58 00000000 c10f68f0 f47d3fe4 c1052834 00000000
2012-03-12T19:02:47.247900+02:00 quick158 kernel: [  209.864024] Call Trace:
2012-03-12T19:02:47.247902+02:00 quick158 kernel: [  209.864149]  
[<c10813c0>] ? rcu_check_callbacks+0x110/0x110
2012-03-12T19:02:47.247905+02:00 quick158 kernel: [  209.864279]  
[<c10f6976>] fsnotify_mark_destroy+0x86/0x120
2012-03-12T19:02:47.247907+02:00 quick158 kernel: [  209.864409]  
[<c10530c0>] ? abort_exclusive_wait+0x80/0x80
2012-03-12T19:02:47.247911+02:00 quick158 kernel: [  209.864537]  
[<c10f68f0>] ? fsnotify_put_mark+0x30/0x30
2012-03-12T19:02:47.247913+02:00 quick158 kernel: [  209.864665]  
[<c1052834>] kthread+0x74/0x80
2012-03-12T19:02:47.247915+02:00 quick158 kernel: [  209.864791]  
[<c10527c0>] ? kthread_flush_work_fn+0x10/0x10
2012-03-12T19:02:47.247918+02:00 quick158 kernel: [  209.864921]  
[<c1582ab6>] kernel_thread_helper+0x6/0xd
2012-03-12T19:02:47.247921+02:00 quick158 kernel: [  209.865047] Code: 
55 f4 8b 45 f8 e9 75 ff ff ff 90 55 89 e5 53 83 ec 14 8b 08 8b 50 04 81 
f9 00 01 10 00 74 24 81 fa 00 02 20 00 0f 84 8e 00 00 00 <8b> 1a 39 d8 
75 62 8b 59 04 39 d8 75
  35 89 51 04 89 0a 83 c4 14
2012-03-12T19:02:47.247924+02:00 quick158 kernel: [  209.868248] EIP: 
[<c1238dd0>] __list_del_entry+0x20/0xe0 SS:ESP 0068:f47d3f64
2012-03-12T19:02:47.247927+02:00 quick158 kernel: [  209.868470] CR2: 
0000000000000000
2012-03-12T19:02:47.247929+02:00 quick158 kernel: [  209.868607] ---[ 
end trace e0fe5151130694c0 ]---

gcc version:
quick158 ~ # gcc -v
Using built-in specs.
COLLECT_GCC=/usr/i686-pc-linux-gnu/gcc-bin/4.5.3/gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/i686-pc-linux-gnu/4.5.3/lto-wrapper
Target: i686-pc-linux-gnu
Configured with: 
/var/tmp/portage/sys-devel/gcc-4.5.3-r1/work/gcc-4.5.3/configure 
--prefix=/usr --bindir=/usr/i686-pc-linux-gnu/gcc-bin/4.5.3 
--includedir=/usr/lib/gcc/i686-pc-linux-gnu/4.5.3/include 
--datadir=/usr/share/gcc-data/i686-pc-linux-gnu/4.5.3 
--mandir=/usr/share/gcc-data/i686-pc-linux-gnu/4.5.3/man 
--infodir=/usr/share/gcc-data/i686-pc-linux-gnu/4.5.3/info 
--with-gxx-include-dir=/usr/lib/gcc/i686-pc-linux-gnu/4.5.3/include/g++-v4 
--host=i686-pc-linux-gnu --build=i686-pc-linux-gnu --disable-altivec 
--disable-fixed-point --without-ppl --without-cloog --disable-lto 
--enable-nls --without-included-gettext --with-system-zlib 
--disable-werror --enable-secureplt --disable-multilib 
--enable-libmudflap --disable-libssp --enable-libgomp 
--with-python-dir=/share/gcc-data/i686-pc-linux-gnu/4.5.3/python 
--enable-checking=release --disable-libgcj --with-arch=i686 
--enable-languages=c,c++,fortran --enable-shared --enable-threads=posix 
--enable-__cxa_atexit --enable-clocale=gnu --enable-targets=all 
--with-bugurl=http://bugs.gentoo.org/ --with-pkgversion='Gentoo 4.5.3-r1 
p1.0, pie-0.4.5'
Thread model: posix
gcc version 4.5.3 (Gentoo 4.5.3-r1 p1.0, pie-0.4.5)

Thank you for your time.

On 11/28/11 19:44, Valentin Avram wrote:
> Hello.
>
> Some of our servers experience an oops on auditd service restart.
> All affected servers are Dell R610, running Gentoo Linux with kernels 
> 2.6.37 and 3.0.6 (both gentoo patched).
> After repeated auditd restarts, the kernel also logs warnings and 
> finally the machine goes unresponsive with the kernel logging on the 
> console CPU stalls.
>
> The affected kernels are a 2.6.37 and a 3.0.6 (gentoo-sources package).
>
> The 2.6.37-r4-gentoo kernel is basically kernel 2.6.37 + patches from 
> mpagano from here:
> http://dev.gentoo.org/~mpagano/genpatches/patches-2.6.37-6.htm
> (
> aka
> http://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-2.6.37-6.base.tar.bz2 
>
> http://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-2.6.37-6.extras.tar.bz2 
>
> )
>
> The 3.0.6-gentoo kernel is also the 3.0.6 kernel + mpagano patches 
> from here:
> http://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-3.0-8.base.tar.bz2 
>
> http://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-3.0-8.extras.tar.bz2 
>
>
> The oops seems to happen at random when restarting the auditd 2.1.3 
> (latest) daemon. Before the crash i can see the [fsnotify_mark] kernel 
> thread, after the oops it is no more.
>
> More data (kernel configs, oops and warning data, dmesg with 
> CONFIG_DEBUG_INFO and CONFIG_DEBUG_LIST enabled, screenshots etc) can 
> be found on the following Gentoo bug:
> https://bugs.gentoo.org/show_bug.cgi?id=389405
>
> Since the activity on the Gentoo bug thread is slow, maybe somebody 
> from here has seen anything similar or has any idea what to do/test next.
>
> Thank you for your time.
>

Valentin Avram.

