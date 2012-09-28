Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab2I1Axu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 20:53:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63928 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2I1Aw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 20:52:56 -0400
Message-ID: <5064F4E2.6010301@gmail.com>
Date: Fri, 28 Sep 2012 10:52:50 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <joerg.roedel@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG_ON/panic proliferation.
References: <20120807134156.GP1996@amd.com> <20120927145217.GA18962@8bytes.org> <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF572@SACEXCMBX04-PRD.hq.netapp.com> <20120927153928.GB18962@8bytes.org> <4FA345DA4F4AE44899BD2B03EEEC2FA908FEF7A3@SACEXCMBX04-PRD.hq.netapp.com> <CA+55aFx5CtDDpXTunJDtkDQWPX7sY0hYMRyekuPErC+s5yXpWw@mail.gmail.com> <20120927173057.GA13142@redhat.com>
In-Reply-To: <20120927173057.GA13142@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/09/12 03:30, Dave Jones wrote:
> On Thu, Sep 27, 2012 at 09:59:13AM -0700, Linus Torvalds wrote:
>
>  > We have too many f*cking BUG_ON's in the kernel, and the fact that one
>  > triggers and it has taken a month and a half without it even being
>  > resolved is a problem.
>
> This has bothered me for a while.
>
> $ rgrep BUG_ON drivers/ | wc -l
> 4018
> $ rgrep WARN_ON drivers/ | wc -l
> 2415
> $ rgrep panic drivers/ | wc -l
> 997
>
> $ rgrep BUG_ON fs | wc -l
> 2792
> $ rgrep WARN_ON fs | wc -l
> 524
> $ rgrep panic fs | wc -l
> 381

The situation isn't quite that bad. Your grep picks up a few variables
with panic in the name and some wrapper functions around panic. This
gets closer to the real counts (still finds some instances in comments):

  $git grep "[^_]panic *(" drivers/  | wc -l
  282

  $git grep "[^_]panic *(" fs/  | wc -l
  53

Some of those look reasonably easy to remove. For example, the panics in
the module_init path for drivers/tty/pty.c could be modified to simply
return -ENOMEM. Something like the below removes 9 panic calls
(completely untested).

~Ryan

---

Remove panic calls from drivers/tty/pty.c
    
There is no need to panic the system if the allocation/registration of
the pty drivers fails. Instead return an error and fail the module load.
    
Signed-off-by: Ryan Mallon <rmallon@gmail.com>

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 5505ffc..69af453 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -382,20 +382,21 @@ static const struct tty_operations slave_pty_ops_bsd = {
 	.resize = pty_resize
 };
 
-static void __init legacy_pty_init(void)
+static int __init legacy_pty_init(void)
 {
 	struct tty_driver *pty_driver, *pty_slave_driver;
+	int err = -ENOMEM;
 
 	if (legacy_count <= 0)
-		return;
+		return 0;
 
 	pty_driver = alloc_tty_driver(legacy_count);
 	if (!pty_driver)
-		panic("Couldn't allocate pty driver");
+		goto fail;
 
 	pty_slave_driver = alloc_tty_driver(legacy_count);
 	if (!pty_slave_driver)
-		panic("Couldn't allocate pty slave driver");
+		goto fail_put_pty_driver;
 
 	pty_driver->driver_name = "pty_master";
 	pty_driver->name = "pty";
@@ -429,13 +430,35 @@ static void __init legacy_pty_init(void)
 	pty_slave_driver->other = pty_driver;
 	tty_set_operations(pty_slave_driver, &slave_pty_ops_bsd);
 
-	if (tty_register_driver(pty_driver))
-		panic("Couldn't register pty driver");
-	if (tty_register_driver(pty_slave_driver))
-		panic("Couldn't register pty slave driver");
+	err = tty_register_driver(pty_driver);
+	if (err)
+		goto fail_put_pty_slave_driver;
+	err = tty_register_driver(pty_slave_driver);
+	if (err)
+		goto fail_unregister_pty_driver;
+
+	return 0;
+
+fail_unregister_pty_driver:
+	tty_unregister_driver(pty_driver);
+fail_put_pty_slave_driver:
+	tty_driver_put(pty_slave_driver);
+fail_put_pty_driver:
+	tty_driver_put(pty_driver);
+fail:
+	return err;
+}
+
+static void __init legacy_pty_free(void)
+{
+	tty_unregister_driver(pty_slave_driver);
+	tty_unregister_driver(pty_driver);
+	tty_driver_put(pty_slave_driver);
+	tty_driver_put(pty_driver);
 }
 #else
 static inline void legacy_pty_init(void) { }
+static inline void legacy_pty_free(void) { }
 #endif
 
 /* Unix98 devices */
@@ -670,14 +693,16 @@ err_file:
 
 static struct file_operations ptmx_fops;
 
-static void __init unix98_pty_init(void)
+static int __init unix98_pty_init(void)
 {
+	int err = -ENOMEM;
+
 	ptm_driver = alloc_tty_driver(NR_UNIX98_PTY_MAX);
 	if (!ptm_driver)
-		panic("Couldn't allocate Unix98 ptm driver");
+		goto fail;
 	pts_driver = alloc_tty_driver(NR_UNIX98_PTY_MAX);
 	if (!pts_driver)
-		panic("Couldn't allocate Unix98 pts driver");
+		goto fail_put_ptm_driver;
 
 	ptm_driver->driver_name = "pty_master";
 	ptm_driver->name = "ptm";
@@ -712,20 +737,40 @@ static void __init unix98_pty_init(void)
 	pts_driver->other = ptm_driver;
 	tty_set_operations(pts_driver, &pty_unix98_ops);
 
-	if (tty_register_driver(ptm_driver))
-		panic("Couldn't register Unix98 ptm driver");
-	if (tty_register_driver(pts_driver))
-		panic("Couldn't register Unix98 pts driver");
+	err = tty_register_driver(ptm_driver);
+	if (err)
+		goto fail_put_pts_driver;
+	err = tty_register_driver(pts_driver);
+	if (err)
+		goto fail_unregister_ptm_driver;
 
 	/* Now create the /dev/ptmx special device */
 	tty_default_fops(&ptmx_fops);
 	ptmx_fops.open = ptmx_open;
 
 	cdev_init(&ptmx_cdev, &ptmx_fops);
-	if (cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1) ||
-	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 2), 1, "/dev/ptmx") < 0)
-		panic("Couldn't register /dev/ptmx driver\n");
+	err = cdev_add(&ptmx_cdev, MKDEV(TTYAUX_MAJOR, 2), 1);
+	if (err)
+		goto fail_unregister_pts_driver;
+	err = register_chrdev_region(MKDEV(TTYAUX_MAJOR, 2), 1, "/dev/ptmx");
+	if (err)
+		goto fail_cdev_del;
+
 	device_create(tty_class, NULL, MKDEV(TTYAUX_MAJOR, 2), NULL, "ptmx");
+	return 0;
+
+fail_cdev_del:
+	cdev_del(&ptmx_cdev);
+fail_unregister_pts_driver:
+	tty_unregister_driver(pts_driver);
+fail_unregister_ptm_driver:
+	tty_unregister_driver(ptm_driver);
+fail_put_pts_driver:
+	tty_put_driver(pts_driver);
+fail_put_ptm_driver:
+	tty_put_driver(ptm_driver);
+fail:
+	return err;
 }
 
 #else
@@ -734,8 +779,17 @@ static inline void unix98_pty_init(void) { }
 
 static int __init pty_init(void)
 {
-	legacy_pty_init();
-	unix98_pty_init();
+	int err;
+
+	err = legacy_pty_init();
+	if (err)
+		return err;
+
+	err = unix98_pty_init();
+	if (err) {
+		legacy_pty_free();
+		return err;
+	}
 	return 0;
 }
 module_init(pty_init);

