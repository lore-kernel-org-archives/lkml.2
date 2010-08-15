Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab0HORIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 13:08:30 -0400
Received: from static.88-198-47-201.clients.your-server.de ([88.198.47.201]:45177
	"EHLO butterbrot.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405Ab0HORI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 13:08:29 -0400
X-Greylist: delayed 4200 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Aug 2010 13:08:28 EDT
Subject: Re: [PATCH] ideapad-laptop: add new driver
From: Florian Echtler <echtler@in.tum.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ike Panhc <ike.pan@canonical.com>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Len Brown <len.brown@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentincj@iksaif.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1281692078.23680.487.camel@localhost>
References: <1281672482-10909-1-git-send-email-ike.pan@canonical.com>
	 <1281690893.23680.475.camel@localhost>  <4C650FFB.7090602@canonical.com>
	 <1281692078.23680.487.camel@localhost>
Content-Type: multipart/mixed; boundary="=-SYCCzAFn6Ysqn2Un1Lmt"
Date: Sun, 15 Aug 2010 10:14:06 +0200
Message-ID: <1281860046.24589.2.camel@flunder>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SYCCzAFn6Ysqn2Un1Lmt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2010-08-13 at 10:34 +0100, David Woodhouse wrote:
> Do you know how to restore it? Or do you have a copy of the 'lenovo-ec'
> module that it apparently contains?
Hello David,

I do have that module: I coaxed it out of Lenovo with the help of
gpl-violations.org as no source was available on my S10-3t. Since it is
flagged as Dual BSD/GPL license, there should be no harm in posting it
here. I hope it helps you in some way.

Florian

--=-SYCCzAFn6Ysqn2Un1Lmt
Content-Disposition: attachment; filename="lenovo_ec.c"
Content-Type: text/x-csrc; name="lenovo_ec.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/*
 * lenovo_s11_ec.c Lenovo_S11 ACPI EC Extras
 */

#include <linux/init.h>
#include <linux/version.h>
#include <linux/module.h>
#include <linux/kernel.h> /* printk() */
#include <linux/slab.h> /* kmalloc() */
#include <linux/fs.h> /* everything... */
#include <linux/errno.h> /* error codes */
#include <linux/types.h> /* size_t */
#include <linux/proc_fs.h>
#include <linux/delay.h>
#include <linux/fcntl.h> /* O_ACCMODE */
#include <asm/system.h> /* cli(), *_flags */
#include <asm/uaccess.h> /* copy_from/to_user */
#include <asm/io.h> /* inb, outb */
#include <linux/sched.h> /* set_cpus_allowed */
#include <linux/acpi.h>
#include <linux/seq_file.h>
#include <acpi/acpi_drivers.h>

#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)
    typedef unsigned long long evaluate_size_t;
#else
    typedef unsigned long evaluate_size_t;
#endif

static DECLARE_MUTEX(gecn_sem);
static DECLARE_MUTEX(secn_sem);

static  struct proc_dir_entry *lenovo_ec_fs_dir;
static char *model = NULL;
struct acpi_lenovo_cs2_device {
        acpi_handle handle;
        char DECN;              
        char GECN;            
        char SECN;            
};

struct acpi_lenovo_cs2_device lenovo_cs2_device;
static acpi_handle vpc0_handle;
MODULE_LICENSE("Dual BSD/GPL");
module_param(model, charp, S_IRUGO);
/*
 *  Proc handle for reading the status of ec device.
 */

static int acpi_s11_ec_read_camera(struct seq_file *seq, void *offset)
{
	char tmp;
	if(ec_read(0xb8,&tmp)){
		printk("ec_read fail\n");
		return -EFAULT;
	}
	seq_printf(seq, "%d\n",!(tmp & 0x8) == 0);
	return 0;
}

static int acpi_s11_ec_read_wifi(struct seq_file *seq, void *offset)
{
	char tmp;
	if(ec_read(0xbb,&tmp)){
		printk("ec_read fail\n");
		return -EFAULT;
	}
	seq_printf(seq, "%d\n",!(tmp & 0x1) == 0);
	return 0;
}

static int acpi_s11_ec_read_dvme(struct seq_file *seq, void *offset)
{
	char tmp;
	if(ec_read(0xb8,&tmp)){
		printk("ec_read fail\n");
		return -EFAULT;
	}
	seq_printf(seq, "%d\n",!(tmp & 0x80) == 0);
	return 0;
}

static int acpi_s11_ec_read_tp(struct seq_file *seq, void *offset)
{
	char tmp;
	if(ec_write(0x00,0x1b)){
		printk("ec_write fail\n");
		return -EFAULT;
	}
	mdelay(10);
	if(ec_read(0x01,&tmp)){
		printk("ec_read_fail\n");
		return -EFAULT;
	}
	seq_printf(seq, "%d\n",tmp);
	return 0;
}

static int acpi_s11_ec_read_antenna(struct seq_file *seq, void *offset)
{
	char tmp;
	if(ec_read(0xbb,&tmp)){
		printk("ec_read_fail\n");
		return -EFAULT;
	}
	seq_printf(seq, "%d\n",!(tmp & 0x10) == 0);
	return 0;
}

static int acpi_s11_ec_read_w3g(struct seq_file *seq, void *offset)
{
        char tmp;
        if(ec_read(0xbb,&tmp)){
                printk("ec_read_fail\n");
                return -EFAULT;
        }
        seq_printf(seq, "%d\n",((tmp >> 6) & 0x1) == 1);
        return 0;
}


static int acpi_s11_ec_read_brightness(struct seq_file *seq, void *offset)
{
	char tmp;
	int i;
	if(ec_read(0xb9,&tmp)){
		printk("ec_read fail\n");
		return -EFAULT;
	}
	seq_printf(seq, "levels: ");
	for(i=0;i<=100;i=i+10)
		seq_printf(seq," %d",i);
	seq_printf(seq, "\ncurrent: %d\n",tmp*10);
	return 0;
}

static int  acpi_s11_ec_write_camera(struct file *file, const char __user *buffer, size_t count, loff_t *data)
{
	char tmp;
	if(buffer[0]!='0' && buffer[0]!='1'){ 
		return count;
		}
	
	if(ec_read(0xb8,&tmp)){
		printk("ec_read fail\n");
		return -EFAULT;
	}
	ec_write(0xb8, buffer[0]== '1' ? (0x08 | tmp) : (~0x08 & tmp));
	return count;
}

static int  acpi_s11_ec_write_wifi(struct file *file, const char __user *buffer, size_t count, loff_t *data)
{
	char tmp;
	if(buffer[0]!='0' && buffer[0]!='1'){ 
		return count;
		}
	if(ec_read(0xbb,&tmp)){
		printk("ec_read fail\n");
		return -EFAULT;
	}
	ec_write(0xbb, buffer[0]== '1' ? (0x01 | tmp) : (~0x01 & tmp));
	return count;
}

static int  acpi_s11_ec_write_dvme(struct file *file, const char __user *buffer, size_t count, loff_t *data)
{
	char tmp;
	if(buffer[0] != '0' && buffer[0] != '1'){ 
		return count;
		}
	
	if(ec_read(0xb8,&tmp)){
		printk("ec_read fail\n");
		return -EFAULT;
	}
	ec_write(0xb8, buffer[0]== '1' ? (0x80 | tmp) : (~0x80 & tmp));
	return count;
}


static int  acpi_s11_ec_write_brightness(struct file *file, const char __user *buffer, size_t count, loff_t *data)
{
	unsigned int level = 0;
	char str[5] = { 0 };
	if(copy_from_user(str,buffer,count))
		return -EFAULT;
	str[count] = 0;
	level = simple_strtoul(str, NULL, 0);
	if(level > 100)
		return -EFAULT;
	if(ec_write(0xb9,(level / 10))){
		printk("ec_write fail\n");
		return -EFAULT;
	}
	return count;
}

static int  acpi_s11_ec_write_w3g(struct file *file, const char __user *buffer, size_t count, loff_t *data)
{
        char tmp;
        if(buffer[0]!='0' && buffer[0]!='1'){
                return count;
                }

        if(ec_read(0xbb,&tmp)){
                printk("ec_read fail\n");
                return -EFAULT;
        }
        ec_write(0xbb, buffer[0]== '1' ? (0x80 | tmp) : (~0x80 & tmp));
        return count;
}



static int acpi_s11_ec_camera_open_fs(struct inode *inode, struct file *file)
{
	return single_open(file, acpi_s11_ec_read_camera, PDE(inode)->data);
}

static int acpi_s11_ec_wifi_open_fs(struct inode *inode, struct file *file)
{
	return single_open(file, acpi_s11_ec_read_wifi, PDE(inode)->data);
}

static int acpi_s11_ec_tp_open_fs(struct inode *inode, struct file *file)
{
	return single_open(file, acpi_s11_ec_read_tp, PDE(inode)->data);
}

static int acpi_s11_ec_antenna_open_fs(struct inode *inode, struct file *file)
{
	return single_open(file, acpi_s11_ec_read_antenna, PDE(inode)->data);
}

static int acpi_s11_ec_w3g_open_fs(struct inode *inode, struct file *file)
{
        return single_open(file, acpi_s11_ec_read_w3g, PDE(inode)->data);
}


static int acpi_s11_ec_dvme_open_fs(struct inode *inode, struct file *file)
{
	return single_open(file, acpi_s11_ec_read_dvme, PDE(inode)->data);
}

static int acpi_s11_ec_brightness_open_fs(struct inode *inode, struct file *file)
{
	return single_open(file, acpi_s11_ec_read_brightness, PDE(inode)->data);
}

static struct file_operations acpi_s11_ec_camera_ops = {
	.open = acpi_s11_ec_camera_open_fs,
	.read = seq_read,
	.write = acpi_s11_ec_write_camera,
	.llseek = seq_lseek,
	.release = single_release,
	.owner = THIS_MODULE,
};

static struct file_operations acpi_s11_ec_wifi_ops = {
	.open = acpi_s11_ec_wifi_open_fs,
	.read = seq_read,
	.write = acpi_s11_ec_write_wifi,
	.llseek = seq_lseek,
	.release = single_release,
	.owner = THIS_MODULE,
};

static struct file_operations acpi_s11_ec_tp_ops = {
	.open = acpi_s11_ec_tp_open_fs,
	.read = seq_read,
	.llseek = seq_lseek,
	.release = single_release,
	.owner = THIS_MODULE,
};

static struct file_operations acpi_s11_ec_antenna_ops = {
	.open = acpi_s11_ec_antenna_open_fs,
	.read = seq_read,
	.llseek = seq_lseek,
	.release = single_release,
	.owner = THIS_MODULE,
};

static struct file_operations acpi_s11_ec_w3g_ops = {
        .open = acpi_s11_ec_w3g_open_fs,
        .read = seq_read,
   	.write = acpi_s11_ec_write_w3g,
        .llseek = seq_lseek,
        .release = single_release,
        .owner = THIS_MODULE,
};

static struct file_operations acpi_s11_ec_dvme_ops = {
	.open = acpi_s11_ec_dvme_open_fs,
	.read = seq_read,
	.write = acpi_s11_ec_write_dvme,
	.llseek = seq_lseek,
	.release = single_release,
	.owner = THIS_MODULE,
};

static struct file_operations acpi_s11_ec_brightness_ops = {
	.open = acpi_s11_ec_brightness_open_fs,
	.read = seq_read,
	.write = acpi_s11_ec_write_brightness,
	.llseek = seq_lseek,
	.release = single_release,
	.owner = THIS_MODULE,
};


static int acpi_s20_ec_read_antenna(struct seq_file *seq, void *offset)
{
	char tmp;
	if(ec_read(0x52,&tmp)){
		printk("ec_read_fail\n");
		return -EFAULT;
	}
	seq_printf(seq, "%d\n",!(tmp & 0x01) == 0);
	return 0;
}

static int acpi_s20_ec_read_w3g(struct seq_file *seq, void *offset)
{
        evaluate_size_t tmp;
        acpi_evaluate_integer(vpc0_handle, "_CFG", NULL,
                                             &tmp);
        seq_printf(seq, "%d\n",((tmp >> 17) & 0x1) == 1);
        return 0;
}

static int acpi_s20_ec_read_wifi(struct seq_file *seq, void *offset)
{
	char tmp;
	if(ec_read(0x71,&tmp)){
		printk("ec_read fail\n");
		return -EFAULT;
	}
	seq_printf(seq, "%d\n",!(tmp & 0x1) == 0);
	return 0;
}

static int acpi_s20_ec_antenna_open_fs(struct inode *inode, struct file *file)
{
	return single_open(file, acpi_s20_ec_read_antenna, PDE(inode)->data);
}

static int acpi_s20_ec_w3g_open_fs(struct inode *inode, struct file *file)
{
        return single_open(file, acpi_s20_ec_read_w3g, PDE(inode)->data);
}

static int acpi_s20_ec_wifi_open_fs(struct inode *inode, struct file *file)
{
        return single_open(file, acpi_s20_ec_read_wifi, PDE(inode)->data);
}

static struct file_operations acpi_s20_ec_antenna_ops = {
	.open = acpi_s20_ec_antenna_open_fs,
	.read = seq_read,
	.llseek = seq_lseek,
	.release = single_release,
	.owner = THIS_MODULE,
};

static struct file_operations acpi_s20_ec_w3g_ops = {
        .open = acpi_s20_ec_w3g_open_fs,
        .read = seq_read,
        .llseek = seq_lseek,
        .release = single_release,
        .owner = THIS_MODULE,
};

static struct file_operations acpi_s20_ec_wifi_ops = {
        .open = acpi_s20_ec_wifi_open_fs,
        .read = seq_read,
        .llseek = seq_lseek,
        .release = single_release,
        .owner = THIS_MODULE,
};

static int acpi_cs2_ec_read_w3g(struct seq_file *seq, void *offset)
{
        evaluate_size_t tmp;
        union acpi_object arg0 = { ACPI_TYPE_INTEGER };
        struct acpi_object_list args = { 1, &arg0 };
        arg0.integer.value = 4;
        if (lenovo_cs2_device.GECN != 1){
                seq_printf(seq, "No device\n");
                return 0;
        }
        else{   
                if (down_interruptible(&gecn_sem)){
                        return -ERESTARTSYS;
                }
                acpi_evaluate_integer(lenovo_cs2_device.handle, "GECN", &args, &tmp);
                up(&gecn_sem);
                seq_printf(seq, "%d\n",(int)tmp);
                return 0;
        }
}


static int acpi_cs2_ec_read_antenna(struct seq_file *seq, void *offset)
{
        evaluate_size_t tmp;
        union acpi_object arg0 = { ACPI_TYPE_INTEGER };
        struct acpi_object_list args = { 1, &arg0 };
        arg0.integer.value = 5;
        if (lenovo_cs2_device.GECN != 1){
                seq_printf(seq, "No device\n");
                return 0;
        }
        else{
                if (down_interruptible(&gecn_sem)){
                        return -ERESTARTSYS;
                }
                acpi_evaluate_integer(lenovo_cs2_device.handle, "GECN", &args, &tmp);
                up(&gecn_sem);
                seq_printf(seq, "%d\n",(int)tmp);
                return 0;
        }

}

static int acpi_cs2_ec_read_wifi(struct seq_file *seq, void *offset)
{
        evaluate_size_t tmp;
        union acpi_object arg0 = { ACPI_TYPE_INTEGER };
        struct acpi_object_list args = { 1, &arg0 };
        arg0.integer.value = 2;
        if (lenovo_cs2_device.GECN != 1){
                seq_printf(seq, "No device\n");
                return 0;
        }
        else{
                if (down_interruptible(&gecn_sem)){
                        return -ERESTARTSYS;
                }
                acpi_evaluate_integer(lenovo_cs2_device.handle, "GECN", &args, &tmp);
                up(&gecn_sem);
                seq_printf(seq, "%d\n",(int)tmp);
                return 0;
        }

}

static int acpi_cs2_ec_read_camera(struct seq_file *seq, void *offset)
{
        evaluate_size_t tmp;
        union acpi_object arg0 = { ACPI_TYPE_INTEGER };
        struct acpi_object_list args = { 1, &arg0 };
        arg0.integer.value = 1;
        if (lenovo_cs2_device.GECN != 1){
                seq_printf(seq, "No device\n");
                return 0;
        }
        else{
                if (down_interruptible(&gecn_sem)){
                        return -ERESTARTSYS;
                }
                acpi_evaluate_integer(lenovo_cs2_device.handle, "GECN", &args, &tmp);
                up(&gecn_sem);
                seq_printf(seq, "%d\n",(int)tmp);
                return 0;
        }

}

static int acpi_cs2_ec_read_bluetooth(struct seq_file *seq, void *offset)
{
        evaluate_size_t tmp;
        union acpi_object arg0 = { ACPI_TYPE_INTEGER };
        struct acpi_object_list args = { 1, &arg0 };
        arg0.integer.value = 3;
        if (lenovo_cs2_device.GECN != 1){
                seq_printf(seq, "No device\n");
                return 0;
        }
        else{
                if (down_interruptible(&gecn_sem)){
                        return -ERESTARTSYS;
                }
                acpi_evaluate_integer(lenovo_cs2_device.handle, "GECN", &args, &tmp);
                up(&gecn_sem);
                seq_printf(seq, "%d\n",(int)tmp);
                return 0;
        }

}

static int  acpi_cs2_ec_write_camera(struct file *file, const char __user *buffer, size_t count, loff_t *data)
{
        union acpi_object in_arg[2];
        struct acpi_object_list args = { 2, in_arg };
        if(buffer[0]!='0' && buffer[0]!='1'){
                return count;
                }
        in_arg[0].type = ACPI_TYPE_INTEGER;
        in_arg[0].integer.value = 1;
        in_arg[1].type = ACPI_TYPE_INTEGER;
        in_arg[1].integer.value = (buffer[0] == '1');
        if (lenovo_cs2_device.SECN == 1){
                if (down_interruptible(&secn_sem)){
                        return -ERESTARTSYS;
                }
                acpi_evaluate_object(lenovo_cs2_device.handle, "SECN", &args, NULL);
                up(&secn_sem);
        }
        return count;
}

static int  acpi_cs2_ec_write_wifi(struct file *file, const char __user *buffer, size_t count, loff_t *data)
{
        union acpi_object in_arg[2];
        struct acpi_object_list args = { 2, in_arg };
        if(buffer[0]!='0' && buffer[0]!='1'){
                return count;
                }
        in_arg[0].type = ACPI_TYPE_INTEGER;
        in_arg[0].integer.value = 2;
        in_arg[1].type = ACPI_TYPE_INTEGER;
        in_arg[1].integer.value = (buffer[0] == '1');
        if (lenovo_cs2_device.SECN == 1){
                if (down_interruptible(&secn_sem)){
                        return -ERESTARTSYS;
                }
                acpi_evaluate_object(lenovo_cs2_device.handle, "SECN", &args, NULL);
                up(&secn_sem);
        }
        return count;
}

static int  acpi_cs2_ec_write_w3g(struct file *file, const char __user *buffer, size_t count, loff_t *data)
{
        union acpi_object in_arg[2];
        struct acpi_object_list args = { 2, in_arg };
        if(buffer[0]!='0' && buffer[0]!='1'){
                return count;
                }
        in_arg[0].type = ACPI_TYPE_INTEGER;
        in_arg[0].integer.value = 4;
        in_arg[1].type = ACPI_TYPE_INTEGER;
        in_arg[1].integer.value = (buffer[0] == '1');
        if (lenovo_cs2_device.SECN == 1){
                if (down_interruptible(&secn_sem)){
                        return -ERESTARTSYS;
                }
                acpi_evaluate_object(lenovo_cs2_device.handle, "SECN", &args, NULL);
                up(&secn_sem);
        }
        return count;
}

static int  acpi_cs2_ec_write_bluetooth(struct file *file, const char __user *buffer, size_t count, loff_t *data)
{
        union acpi_object in_arg[2];
        struct acpi_object_list args = { 2, in_arg };
        if(buffer[0]!='0' && buffer[0]!='1'){
                return count;
                }
        in_arg[0].type = ACPI_TYPE_INTEGER;
        in_arg[0].integer.value = 3;
        in_arg[1].type = ACPI_TYPE_INTEGER;
        in_arg[1].integer.value = (buffer[0] == '1');
        if (lenovo_cs2_device.SECN == 1){
                if (down_interruptible(&secn_sem)){
                        return -ERESTARTSYS;
                }
                acpi_evaluate_object(lenovo_cs2_device.handle, "SECN", &args, NULL);
                up(&secn_sem);
        }
        return count;
}

static int acpi_cs2_ec_antenna_open_fs(struct inode *inode, struct file *file)
{
        return single_open(file, acpi_cs2_ec_read_antenna, PDE(inode)->data);
}

static int acpi_cs2_ec_w3g_open_fs(struct inode *inode, struct file *file)
{
        return single_open(file, acpi_cs2_ec_read_w3g, PDE(inode)->data);
}

static int acpi_cs2_ec_wifi_open_fs(struct inode *inode, struct file *file)
{
        return single_open(file, acpi_cs2_ec_read_wifi, PDE(inode)->data);
}

static int acpi_cs2_ec_camera_open_fs(struct inode *inode, struct file *file)
{
        return single_open(file, acpi_cs2_ec_read_camera, PDE(inode)->data);
}

static int acpi_cs2_ec_bluetooth_open_fs(struct inode *inode, struct file *file)
{
        return single_open(file, acpi_cs2_ec_read_bluetooth, PDE(inode)->data);
}

static struct file_operations acpi_cs2_ec_antenna_ops = {
        .open = acpi_cs2_ec_antenna_open_fs,
        .read = seq_read,
        .llseek = seq_lseek,
        .release = single_release,
        .owner = THIS_MODULE,
};

static struct file_operations acpi_cs2_ec_w3g_ops = {
        .open = acpi_cs2_ec_w3g_open_fs,
        .read = seq_read,
	.write = acpi_cs2_ec_write_w3g,
        .llseek = seq_lseek,
        .release = single_release,
        .owner = THIS_MODULE,
};

static struct file_operations acpi_cs2_ec_wifi_ops = {
        .open = acpi_cs2_ec_wifi_open_fs,
        .read = seq_read,
	.write = acpi_cs2_ec_write_wifi,
        .llseek = seq_lseek,
        .release = single_release,
        .owner = THIS_MODULE,
};

static struct file_operations acpi_cs2_ec_camera_ops = {
        .open = acpi_cs2_ec_camera_open_fs,
        .read = seq_read,
	.write = acpi_cs2_ec_write_camera,
        .llseek = seq_lseek,
        .release = single_release,
        .owner = THIS_MODULE,
};

static struct file_operations acpi_cs2_ec_bluetooth_ops = {
        .open = acpi_cs2_ec_bluetooth_open_fs,
        .read = seq_read,
        .write = acpi_cs2_ec_write_bluetooth,
        .llseek = seq_lseek,
        .release = single_release,
        .owner = THIS_MODULE,
};

static int acpi_m3b_ec_read_antenna(struct seq_file *seq, void *offset)
{
        char tmp;
        if(ec_read(0x52,&tmp)){
                printk("ec_read_fail\n");
                return -EFAULT;
        }
        seq_printf(seq, "%d\n",!(tmp & 0x01) == 0);
        return 0;
}

static int acpi_m3b_ec_antenna_open_fs(struct inode *inode, struct file *file)
{
        return single_open(file, acpi_m3b_ec_read_antenna, PDE(inode)->data);
}

static struct file_operations acpi_m3b_ec_antenna_ops = {
        .open = acpi_m3b_ec_antenna_open_fs,
        .read = seq_read,
        .llseek = seq_lseek,
        .release = single_release,
        .owner = THIS_MODULE,
};

/*
 * This function is used to regiter the ec device's proc file and operations
 */
static int lenovo_ec_proc_add(char *name,struct file_operations *acpi_ec_ops,struct proc_dir_entry *dir)
{
	struct proc_dir_entry * entry = NULL;
	entry = create_proc_entry(name, S_IRUGO,
				  dir);
	if (!entry)
		return -ENODEV;
	else {
		entry->proc_fops = acpi_ec_ops;
		entry->data = NULL;
		entry->owner = THIS_MODULE;
	}
	return 0;
}

/*
 * The lenovo S11 has six ec devices : camera, wifi, brightness controller, touch pad, dvm enalbe, antenna.
 */

static int lenovo_s11_ec_init(void)
{
	int result;
	printk("Lenovo s11 ec driver init\n");
	result = lenovo_ec_proc_add("camera",&acpi_s11_ec_camera_ops,lenovo_ec_fs_dir);
	if(result == -ENODEV)
		return result;
	result = lenovo_ec_proc_add("wifi", &acpi_s11_ec_wifi_ops,lenovo_ec_fs_dir);
	if(result == -ENODEV)
		return result;
	result = lenovo_ec_proc_add("tp", &acpi_s11_ec_tp_ops,lenovo_ec_fs_dir);
	if(result == -ENODEV)
		return result;
	result = lenovo_ec_proc_add("dvme", &acpi_s11_ec_dvme_ops,lenovo_ec_fs_dir);
	if(result == -ENODEV)
		return result;
	result = lenovo_ec_proc_add("brightness", &acpi_s11_ec_brightness_ops,lenovo_ec_fs_dir);
	if(result == -ENODEV)
		return result;
	result = lenovo_ec_proc_add("antenna", &acpi_s11_ec_antenna_ops,lenovo_ec_fs_dir);
	if(result == -ENODEV)
		return result;
        result = lenovo_ec_proc_add("w3g", &acpi_s11_ec_w3g_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;

	return 0;
}

static void lenovo_s11_ec_exit(void)
{
	printk("Lenovo_s11 ec driver remove\n");
	remove_proc_entry("camera", lenovo_ec_fs_dir);
	remove_proc_entry("wifi", lenovo_ec_fs_dir);
	remove_proc_entry("tp", lenovo_ec_fs_dir);
	remove_proc_entry("dvme", lenovo_ec_fs_dir);
	remove_proc_entry("brightness", lenovo_ec_fs_dir);
	remove_proc_entry("antenna", lenovo_ec_fs_dir);
	remove_proc_entry("w3g", lenovo_ec_fs_dir);
	return;
}

static acpi_status
find_vpc0(acpi_handle handle, u32 lvl, void *context, void **rv)
{

        char prefix[80] = {'\0'};
	int *vpc;
        struct acpi_buffer buffer = {sizeof(prefix), prefix };
	vpc = context;
        acpi_get_name(handle, ACPI_SINGLE_NAME, &buffer);

        if (strcmp(prefix,"VPC0") == 0){
                vpc0_handle = handle;
		*vpc = 1;
                }
        return AE_OK;
}

static int lenovo_s20_vpn_init(void)
{
	int vpc0 = 0;
        acpi_handle h_dummy1;
	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
			ACPI_UINT32_MAX, find_vpc0, &vpc0, NULL);
	if (vpc0 == 1){
        	if (ACPI_SUCCESS(acpi_get_handle(vpc0_handle, "_CFG", &h_dummy1)))
			return 0;
		}
	return -1;
}


static int lenovo_s20_ec_init(void)
{
	int result;
	printk("Lenovo s20 ec driver init\n");
	result =  lenovo_s20_vpn_init();
        if(result == -1)
                return -ENODEV;
	result = lenovo_ec_proc_add("antenna",&acpi_s20_ec_antenna_ops,lenovo_ec_fs_dir);
	if(result == -ENODEV)
		return result;
        result = lenovo_ec_proc_add("w3g",&acpi_s20_ec_w3g_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        result = lenovo_ec_proc_add("wifi",&acpi_s20_ec_wifi_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
	return 0;
}

static void lenovo_s20_ec_exit(void)
{
	printk("Lenovo_s20 ec driver remove\n");
	remove_proc_entry("antenna", lenovo_ec_fs_dir);
	remove_proc_entry("w3g", lenovo_ec_fs_dir);
	remove_proc_entry("wifi", lenovo_ec_fs_dir);
}

static acpi_status
find_sb(acpi_handle handle, u32 lvl, void *context, void **rv)
{

        char prefix[80] = {'\0'};
        int *sb;
        struct acpi_buffer buffer = {sizeof(prefix), prefix };
        sb = context;
        acpi_get_name(handle, ACPI_SINGLE_NAME, &buffer);
        if (strcmp(prefix,"_SB_") == 0){
                lenovo_cs2_device.handle = handle;
                *sb = 1;
                }
        return AE_OK;
}

static int lenovo_cs2_rootpath_init(void)
{
        int sb = 0;
        acpi_handle h_dummy1;
        acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
                        ACPI_UINT32_MAX, find_sb, &sb, NULL);
        if (sb == 1){
                if (ACPI_SUCCESS(acpi_get_handle(lenovo_cs2_device.handle, "DECN", &h_dummy1)))
                        lenovo_cs2_device.DECN = 1;
                else
                        lenovo_cs2_device.DECN = 0;
                if (ACPI_SUCCESS(acpi_get_handle(lenovo_cs2_device.handle, "SECN", &h_dummy1)))
                        lenovo_cs2_device.SECN = 1;
                else
                        lenovo_cs2_device.SECN = 0;
                if (ACPI_SUCCESS(acpi_get_handle(lenovo_cs2_device.handle, "GECN", &h_dummy1)))
                        lenovo_cs2_device.GECN = 1;
                else
                        lenovo_cs2_device.GECN = 0;
                return 0;
        }
        else{
                lenovo_cs2_device.GECN = 0;
                lenovo_cs2_device.SECN = 0;
                lenovo_cs2_device.DECN = 0;
                return -1;
        }
}

static int lenovo_cs2_ec_init(void)
{
        int result;
        printk("Lenovo cs2 ec driver init\n");
        result =  lenovo_cs2_rootpath_init();
        if(result == -1)
                return -ENODEV;
        result = lenovo_ec_proc_add("antenna",&acpi_cs2_ec_antenna_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        result = lenovo_ec_proc_add("w3g",&acpi_cs2_ec_w3g_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        result = lenovo_ec_proc_add("wifi",&acpi_cs2_ec_wifi_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        result = lenovo_ec_proc_add("camera",&acpi_cs2_ec_camera_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        result = lenovo_ec_proc_add("bluetooth",&acpi_cs2_ec_bluetooth_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        return 0;
}

static void lenovo_cs2_ec_exit(void)
{
        printk("Lenovo_cs2 ec driver remove\n");
        remove_proc_entry("antenna", lenovo_ec_fs_dir);
        remove_proc_entry("w3g", lenovo_ec_fs_dir);
        remove_proc_entry("wifi", lenovo_ec_fs_dir);
        remove_proc_entry("camera", lenovo_ec_fs_dir);
}

static int lenovo_m3b_ec_init(void)
{
        /* Use the acpi method interface same as Lenovo CS2*/
        int result;
        printk("Lenovo mariana-3b ec driver init\n");
        result =  lenovo_cs2_rootpath_init();
        if(result == -1)
                return -ENODEV;
        result = lenovo_ec_proc_add("antenna",&acpi_cs2_ec_antenna_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        result = lenovo_ec_proc_add("w3g",&acpi_cs2_ec_w3g_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        result = lenovo_ec_proc_add("wifi",&acpi_cs2_ec_wifi_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        result = lenovo_ec_proc_add("camera",&acpi_cs2_ec_camera_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        result = lenovo_ec_proc_add("bluetooth",&acpi_cs2_ec_bluetooth_ops,lenovo_ec_fs_dir);
        if(result == -ENODEV)
                return result;
        return 0;
}

static void lenovo_m3b_ec_exit(void)
{
        printk("Lenovo mariana-3b ec driver remove\n");
        remove_proc_entry("antenna", lenovo_ec_fs_dir);
}

static int lenovo_ec_init(void)
{
	lenovo_ec_fs_dir = proc_mkdir("lenovo",acpi_root_dir);
        if (model != NULL){
	    if (strncmp(model, "S11", 3) == 0)
                lenovo_s11_ec_init();
	    else if (strncmp(model, "S20", 3) == 0)
	        lenovo_s20_ec_init();
	    else if (strncmp(model, "CS2", 3) == 0)
                lenovo_cs2_ec_init();
	    else if (strncmp(model, "M3B", 3) == 0)
                lenovo_m3b_ec_init();
        }
	return 0;
}

static void lenovo_ec_exit(void)
{
        if (model != NULL){
	    if (strncmp(model, "S11", 3) == 0)
		lenovo_s11_ec_exit();
	    else if (strncmp(model, "S20", 3) == 0)
		lenovo_s20_ec_exit();
	    else if (strncmp(model, "CS2", 3) == 0)
	        lenovo_cs2_ec_exit();
	    else if (strncmp(model, "M3B", 3) == 0)
	        lenovo_m3b_ec_exit();
        }
	remove_proc_entry("lenovo", acpi_root_dir);
}

module_init(lenovo_ec_init);
module_exit(lenovo_ec_exit);


--=-SYCCzAFn6Ysqn2Un1Lmt--

