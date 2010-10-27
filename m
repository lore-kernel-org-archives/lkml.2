Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959Ab0J0Lb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:31:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:37307 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858Ab0J0Lb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:31:57 -0400
Date: Wed, 27 Oct 2010 13:31:53 +0200
From: "Dr. Werner Fink" <werner@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 28/49] tty: Add a new file /proc/tty/consoles
Message-ID: <20101027113152.GA30513@boole.suse.de>
Mail-Followup-To: Jiri Slaby <jslaby@suse.cz>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20101022175112.GC13489@kroah.com>
 <1287771688-14805-28-git-send-email-gregkh@suse.de>
 <4CC2C9A8.1040003@suse.cz>
 <20101025075125.GA29179@boole.suse.de>
 <20101027005045.GC19804@ZenIV.linux.org.uk>
 <20101027092744.GA27071@boole.suse.de>
 <4CC7F616.5060404@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <4CC7F616.5060404@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

On Wed, Oct 27, 2010 at 11:51:18AM +0200, Jiri Slaby wrote:
> On 10/27/2010 11:27 AM, Dr. Werner Fink wrote:
> > Such a list would be very helpful e.g. to extend sulogin
> > to be able to prompt for maintenance on all terminal lines
> > of the system console after e.g. failed fsck.  Currently
> > only the preferred terminal line is prompted for maintenance.
> 
> I think nobody objects to the /proc/tty/consoles. This is a good thing
> to have. The patch just needs to be fixed (and you already did and sent
> me in private).
> 
> The objections are against the way how you find out the real tty behind
> /dev/console. The method to walk through fd, guessing private_data etc.
> is simply unacceptable.
> 
> Actually couldn't you just use one of:
> 1) ttyprintk driver (well, this will insert mess into klog)
> 2) send the output to all enabled consoles in /proc/tty/consoles
> ?

Hmmm ... I've wonder about the comment on add_preferred_console()
of kernel/printk.c:

 * add_preferred_console - add a device to the list of preferred consoles.
 * @name: device name
 * @idx: device index
 * @options: options for this console
 *
 * The last preferred console added will be used for kernel messages
 * and stdin/out/err for init.  Normally this is used by console_setup
 * above to handle user-supplied console arguments; however it can also
 * be used by arch-specific code either to override the user or more
 * commonly to provide a default console (ie from PROM variables) when
 * the user has not supplied one.

that is that the first line always provides the preferred terminal
line.  In other words the detection stuff is not required as long
as the statement in the comment for add_preferred_console() will
remain now and in future.  Indeed register_console() reorders the
list of console drivers if the preferred terminal line will be
changed and this line is marked with the flag CON_CONSDEV.

Now as stdin/out/err for init resides on the preferred terminal
line this could be OK.  If a program is runniung on /dev/console
then also its stdin is directed to the preferred console line.

Werner

-- 
System V style init programs - http://savannah.nongnu.org/projects/sysvinit/

--G4iJoqBmSsgzjUCe
Content-Type: text/x-patch; charset=iso-8859-1
Content-Description: Add-a-new-file-proc-tty-consoles.patch
Content-Disposition: attachment; filename="0002-Add-a-new-file-proc-tty-consoles-to-be-able-to.patch"

>From f1c9b9a6d589dfdf85961fe3f8db4cdc9600dc4b Mon Sep 17 00:00:00 2001
From: Werner Fink <werner@suse.de>
Date: Wed, 27 Oct 2010 13:25:26 +0200
Subject: [PATCH] tty: Add a new file /proc/tty/consoles

 Add a new file /proc/tty/consoles to be able to
 determine the registered system console lines.
 If the reading process holds /dev/console open at
 the regular standard input stream the active device
 will be marked by an asterisk.  Show possible
 operations and also decode the used flags of the
 of the listed console lines.

Signed-off-by: Werner Fink <werner@suse.de>

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 9fb6cbe..eeee8d9 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1074,6 +1074,7 @@ Table 1-11: Files in /proc/tty
  drivers       list of drivers and their usage                
  ldiscs        registered line disciplines                    
  driver/serial usage statistic and status of single tty lines 
+ consoles      registered system console lines
 ..............................................................................
 
 To see  which  tty's  are  currently in use, you can simply look into the file
@@ -1092,6 +1093,38 @@ To see  which  tty's  are  currently in use, you can simply look into the file
   /dev/tty             /dev/tty        5       0 system:/dev/tty 
   unknown              /dev/tty        4    1-63 console 
 
+To see which character device lines are currently used for the system console
+/dev/console, you may simply look into the file /proc/tty/consoles:
+
+  > cat /proc/tty/consoles
+  tty0                 -WU (ECp)       4:7
+  ttyS0                -W- (Ep)        4:64
+
+The columns are:
+
+  device               name of the device
+  operations           R = can do read operations
+                       W = can do write operations
+                       U = can do unblank
+  flags                E = it is enabled
+                       C = it is prefered console
+                       B = it is primary boot console
+                       p = it is used for printk buffer
+                       b = it is not a TTY but a Braille device
+                       a = it is safe to use when cpu is offline
+                       * = it is tty line of the reading process
+                       + = it is controlling tty of the reading process
+  major:minor          major and minor number of the device separated by a colon
+
+If the reading process holds /dev/console open at the regular standard input
+stream the active device will be marked by an asterisk:
+
+  > cat /proc/tty/consoles < /dev/console
+  tty0                 -WU (ECp*)      4:7
+  ttyS0                -W- (Ep)        4:64
+  > tty
+  /dev/pts/3
+
 
 1.8 Miscellaneous kernel statistics in /proc/stat
 -------------------------------------------------
diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index 83adcc8..5a6798c 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -12,7 +12,10 @@
 #include <linux/proc_fs.h>
 #include <linux/stat.h>
 #include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/console.h>
 #include <linux/seq_file.h>
+#include <linux/fdtable.h>
 #include <linux/bitops.h>
 
 /*
@@ -137,6 +140,170 @@ static const struct file_operations proc_tty_drivers_operations = {
 };
 
 /*
+ * The device ID of file descriptor 0 of the current reading
+ * task if a character device...
+ */
+struct proc_tty_private {
+	dev_t tty_device;
+	unsigned int on_console:1;
+};
+
+/*
+ * This is the handler for /proc/tty/consoles
+ */
+static int show_console_dev(struct seq_file *m, void *v)
+{
+	struct console *con;
+	int index, len;
+	char flags[10];
+	dev_t dev = 0;
+
+	con = v;
+	if (!con)
+		return 0;
+
+	if (con->device) {
+		const struct tty_driver *driver;
+		driver = con->device(con, &index);
+		if (driver) {
+			dev = MKDEV(driver->major, driver->minor_start);
+			dev += index;
+		}
+	}
+
+	index = 0;
+	if (con->flags & CON_ENABLED)
+		flags[index++] = 'E';
+	if (con->flags & CON_CONSDEV)
+		flags[index++] = 'C';
+	if (con->flags & CON_BOOT)
+		flags[index++] = 'B';
+	if (con->flags & CON_PRINTBUFFER)
+		flags[index++] = 'p';
+	if (con->flags & CON_BRL)
+		flags[index++] = 'b';
+	if (con->flags & CON_ANYTIME)
+		flags[index++] = 'a';
+	if (m->private) {
+		const struct proc_tty_private *priv = m->private;
+		if (priv->on_console && (con->flags & CON_CONSDEV))
+			flags[index++] = '*';
+		if (dev && priv->tty_device == dev)
+			flags[index++] = '+';
+	}
+	flags[index] = 0;
+
+	seq_printf(m, "%s%d%n", con->name, con->index, &len);
+	len = 21 - len;
+	if (len < 1)
+		len = 1;
+	seq_printf(m, "%*c", len, ' ');
+	seq_printf(m, "%c%c%c (%s)%n", con->read ? 'R' : '-',
+			con->write ? 'W' : '-', con->unblank ? 'U' : '-',
+			flags, &len);
+	if (dev) {
+		len = 13 - len;
+		if (len < 1)
+			len = 1;
+		seq_printf(m, "%*c%4d:%d\n", len, ' ', MAJOR(dev), MINOR(dev));
+	}
+
+	return 0;
+}
+
+/*
+ * Determine terminal device of standard input of current task.
+ */
+static void current_console_device(struct proc_tty_private *priv)
+{
+	struct files_struct *files = get_files_struct(current);
+	const struct file *filp;
+	unsigned long flags;
+
+	if (!files)
+		return;
+
+	spin_lock(&files->file_lock);
+	filp = fcheck_files(files, 0);
+	if (filp) {
+		const struct inode *inode;
+		dget(filp->f_dentry);
+		inode = filp->f_dentry->d_inode;
+		if (inode->i_rdev == MKDEV(TTYAUX_MAJOR, 1))
+			priv->on_console = 1;
+		dput(filp->f_dentry);
+	}
+	spin_unlock(&files->file_lock);
+	put_files_struct(files);
+
+	if (lock_task_sighand(current, &flags)) {
+		struct signal_struct *sig = current->signal;
+		if (sig->tty)
+			priv->tty_device = tty_devnum(sig->tty);
+		unlock_task_sighand(current, &flags);
+	}
+}
+
+static void *c_start(struct seq_file *m, loff_t *pos)
+{
+	struct proc_tty_private *priv;
+	struct console *con;
+	loff_t off = 0;
+
+	m->private = NULL;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (priv) {
+		current_console_device(priv);
+		m->private = priv;
+	}
+
+	acquire_console_sem();
+	for (con = console_drivers; con; con = con->next) {
+		if (off++ == *pos)
+			break;
+	}
+	return con;
+}
+
+static void *c_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct console *con = v;
+	con = con->next;
+	if (con)
+		++*pos;
+	return con;
+}
+
+static void c_stop(struct seq_file *m, void *v)
+{
+	release_console_sem();
+	kfree(m->private);
+}
+
+static const struct seq_operations tty_consoles_op = {
+	.start	= c_start,
+	.next	= c_next,
+	.stop	= c_stop,
+	.show	= show_console_dev
+};
+
+/* iterator for consoles */
+/*
+ * Used for open /proc/tty/consoles.
+ */
+static int tty_consoles_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &tty_consoles_op);
+}
+
+static const struct file_operations proc_tty_consoles_operations = {
+	.open		= tty_consoles_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+/*
  * This function is called by tty_register_driver() to handle
  * registering the driver's /proc handler into /proc/tty/driver/<foo>
  */
@@ -186,4 +353,5 @@ void __init proc_tty_init(void)
 	proc_tty_driver = proc_mkdir_mode("tty/driver", S_IRUSR|S_IXUSR, NULL);
 	proc_create("tty/ldiscs", 0, NULL, &tty_ldiscs_proc_fops);
 	proc_create("tty/drivers", 0, NULL, &proc_tty_drivers_operations);
+	proc_create("tty/consoles", 0, NULL, &proc_tty_consoles_operations);
 }
-- 
1.6.0.2


--G4iJoqBmSsgzjUCe--
