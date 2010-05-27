Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227Ab0E0WmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 18:42:09 -0400
Received: from forward12.mail.yandex.net ([95.108.130.94]:51173 "EHLO
	forward12.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab0E0WmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 18:42:04 -0400
From: Sergey Temerkhanov <temerkhanov@yandex.ru>
Organization: Cifronic ZAO
Subject: Kernel module and 2 programs for AIO cancellation testing
Date: Fri, 28 May 2010 02:35:44 +0400
User-Agent: KMail/1.12.4 (Linux/2.6.34-40-desktop; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
To: "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_APv/Lqw0Miwi0ny"
Message-Id: <201005280235.44683.temerkhanov@yandex.ru>
X-Yandex-TimeMark: 1274999749
X-Yandex-Spam: 1
X-Yandex-Front: smtp14.mail.yandex.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_APv/Lqw0Miwi0ny
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

The attached files are respectively:
  - a kernel module which implements 4 pseudo-devices with different
    aio_read/aio_write methods:
	- aiotest0 simply returns -EIOCBQUEUED;
   	- aiotest1 sets ki_cancel method and returns -EIOCBQUEUED;
	- aiotest2 sets KIF_CANCELLED flag and returns -EINTR;
	- aiotest3 sets ki_cancel method and returns -EIOCBQUEUED after 1 second;

  - a program test_aio.c which submits 1 AIO request and calls
    io_destroy() after 1 second timeout
  - a program test_aio.c which submits 1 AIO request and calls
    io_cancel() on that request immediately.

-- 
Regards, Sergey Temerkhanov,
Cifronic ZAO

--Boundary-00=_APv/Lqw0Miwi0ny
Content-Type: text/x-csrc;
  charset="utf-8";
  name="aio_tester.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aio_tester.c"

#include <linux/module.h>
#include <linux/init.h>
#include <linux/fs.h>
#include <linux/sched.h>
#include <linux/delay.h>
#include <linux/device.h>
#include <linux/cdev.h>
#include <linux/slab.h>
#include <linux/aio.h>


#if 1
#define dprintk(fmt...)	printk(fmt)
#else
#define dprintk(fmt...)
#endif

LIST_HEAD(aiotest_devs);

static struct class *aiotest_class = NULL;

int aiotest_major = 0;


MODULE_AUTHOR("Sergey Temerkhanov");
MODULE_DESCRIPTION("AIO tester module");
MODULE_LICENSE("GPL");


struct aiotest_dev {
	struct list_head	list;
	
	wait_queue_head_t	waitq;
	struct cdev		cdev;
	atomic_t		opened;
	int			index;

	struct delayed_work	work;
};

#define AIOTEST_NUMDEVS 1

//----------------------------------------------------------------------------
static int aiotest_open(struct inode *inode, struct file *file)
{
	struct aiotest_dev *dev;
	
	dev = container_of(inode->i_cdev, struct aiotest_dev, cdev);

	file->private_data = dev;

	if (!file->private_data)
		return -ENODEV;

	if (atomic_read(&dev->opened))
		return -EBUSY;

	atomic_inc(&dev->opened);

	return 0;
}

static int aiotest_release(struct inode *inode, struct file *file)
{
	struct aiotest_dev *dev;

	dev = file->private_data;

	if (!dev)
		return -ENODEV;

	atomic_dec(&dev->opened);

	return 0;
}

int aiotest_cancel(struct kiocb* iocb, struct io_event* evt)
{
	printk("%s: %d: iocb: %p, iocb->ki_users: %d\n",
	       __FUNCTION__, __LINE__, iocb, iocb->ki_users);
	aio_put_req(iocb);

	printk("%s: %d: iocb: %p, iocb->ki_users: %d\n",
	       __FUNCTION__, __LINE__, iocb, iocb->ki_users);

	return 0;
}

ssize_t aiotest_rw_ki_cancel(struct kiocb *iocb, const struct iovec* iov,
		    unsigned long count, loff_t off)
{
	printk("%s: %d: iocb: %p, iocb->ki_users: %d\n",
	       __FUNCTION__, __LINE__, iocb, iocb->ki_users);

	iocb->ki_cancel = aiotest_cancel;

	return -EIOCBQUEUED;
}

ssize_t aiotest_rw_nocancel(struct kiocb *iocb, const struct iovec* iov,
				  unsigned long count, loff_t off)
{
	printk("%s: %d: iocb: %p, iocb->ki_users: %d\n",
		__FUNCTION__, __LINE__, iocb, iocb->ki_users);

	return -EIOCBQUEUED;
}

ssize_t aiotest_rw_setcancelled(struct kiocb *iocb, const struct iovec* iov,
					unsigned long count, loff_t off)
{
	printk("%s: %d: iocb: %p, iocb->ki_users: %d\n",
		__FUNCTION__, __LINE__, iocb, iocb->ki_users);

	kiocbSetCancelled(iocb);
	return -EINTR;
}

ssize_t aiotest_rw_delayed(struct kiocb *iocb, const struct iovec* iov,
			unsigned long count, loff_t off)
{
	printk("%s: %d: iocb: %p, iocb->ki_users: %d\n",
			__FUNCTION__, __LINE__, iocb, iocb->ki_users);

	iocb->ki_cancel = aiotest_cancel;

	schedule_timeout(HZ);
	return -EIOCBQUEUED;
}

// ---------------------------------------------------------------------------
static struct file_operations aiotest_fops_nocancel = {
	.owner	   = THIS_MODULE,
	.open	   = aiotest_open,
	.release   = aiotest_release,
	.aio_read  = aiotest_rw_nocancel,
	.aio_write = aiotest_rw_nocancel,
};

static struct file_operations aiotest_fops_ki_cancel = {
	.owner	   = THIS_MODULE,
	.open	   = aiotest_open,
	.release   = aiotest_release,
	.aio_read  = aiotest_rw_ki_cancel,
	.aio_write = aiotest_rw_ki_cancel,
};

static struct file_operations aiotest_fops_setcancelled = {
	.owner	   = THIS_MODULE,
	.open	   = aiotest_open,
	.release   = aiotest_release,
	.aio_read  = aiotest_rw_setcancelled,
	.aio_write = aiotest_rw_setcancelled,
};

static struct file_operations aiotest_fops_delayed = {
	.owner	   = THIS_MODULE,
	.open	   = aiotest_open,
	.release   = aiotest_release,
	.aio_read  = aiotest_rw_delayed,
	.aio_write = aiotest_rw_delayed,
};


static void aiotest_cleanup(struct aiotest_dev *dev)
{
	if (!dev) 
		return;

	device_destroy(aiotest_class, dev->cdev.dev);

	cdev_del(&dev->cdev);

	list_del(&dev->list);

	kfree(dev);
};

static int init_aiotest_dev(int index, struct file_operations *fops)
{
	struct aiotest_dev *dev;
	int res;

	dev = kzalloc(sizeof(struct aiotest_dev), GFP_KERNEL);

	if (!dev)
		return -ENOMEM;

	dev->index = index;

	device_create(aiotest_class, NULL,
			    MKDEV(aiotest_major, dev->index), NULL,
			    "aiotest%d", index);

	cdev_init(&dev->cdev, fops);
	res = cdev_add(&dev->cdev, MKDEV(aiotest_major, dev->index), 1);

	if (res) {
		aiotest_cleanup(dev);
		return res;
	}

	init_waitqueue_head(&dev->waitq);

	atomic_set(&dev->opened, 0);

	list_add_tail(&dev->list, &aiotest_devs);

	return 0;
}

// ---------------------------------------------------------------------------

static void __exit aiodrv_cleanup(void);

static int __init aiodrv_init(void)
{
	dev_t device;
	int res;

	res = alloc_chrdev_region(&device, 0,
				  AIOTEST_NUMDEVS, "aiotest");
	aiotest_major = MAJOR(device);

	if (res < 0) {
		printk(KERN_ERR "Cannot get major number for aiotest\n");
		return res;
	}

	aiotest_class = class_create(THIS_MODULE, "aiotest");

	init_aiotest_dev(0, &aiotest_fops_nocancel);
	init_aiotest_dev(1, &aiotest_fops_ki_cancel);
	init_aiotest_dev(2, &aiotest_fops_setcancelled);
	init_aiotest_dev(3, &aiotest_fops_delayed);

	return 0;
};

static void __exit aiodrv_cleanup(void)
{
	struct aiotest_dev *dev, *next;

	list_for_each_entry_safe(dev, next, &aiotest_devs, list) {
		aiotest_cleanup(dev);
	}

	if (aiotest_class)
		class_destroy(aiotest_class);

	unregister_chrdev_region(MKDEV(aiotest_major, 0),
				 AIOTEST_NUMDEVS);
};


module_init(aiodrv_init);
module_exit(aiodrv_cleanup);

--Boundary-00=_APv/Lqw0Miwi0ny
Content-Type: text/x-csrc;
  charset="utf-8";
  name="test_aio.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="test_aio.c"

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/uio.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>
#include <libaio.h>
#include <stdlib.h>
#include <stdio.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

const char usage[] = "Usage: test_aio [filename]";

int main(int argc, char *argv[])
{
	int res, i;
	struct timespec tspec;

	uint64_t data = 0xa5a5a5a5a5a5a5a5ULL;

	unsigned int iocbs_num = 1;

	struct iocb iocb_i[iocbs_num];
	struct iocb *iocbs[iocbs_num];
	struct io_event events[iocbs_num];
	io_context_t io_ctx;

	int fd;

	if (argc < 2) {
		fputs(usage, stderr);
		exit(1);
	}

	for (i = 0; i < iocbs_num; i++)
		iocbs[i] = &iocb_i[i];

	fd = open(argv[1], O_RDWR | O_SYNC);

	if (fd < 0) {
		perror("open");
		exit(1);
	}

	res = io_queue_init(iocbs_num, &io_ctx);

	if (res != 0) {
		fprintf(stderr, strerror(-res));
		exit(1);
	}

	int num_io = 1;

	io_prep_pread(iocbs[0], fd, &data, sizeof(data), 0);

	res = io_submit(io_ctx, num_io, iocbs);

	if (res != num_io) {
		fprintf(stderr, strerror(-res));
		exit(1);
	}

	tspec.tv_nsec = 0;
	tspec.tv_sec = 1;

	res = io_getevents(io_ctx, num_io, num_io, events, &tspec);

	printf("io_getevents: %d", res);

	io_queue_release(io_ctx);

	close(fd);
}

--Boundary-00=_APv/Lqw0Miwi0ny
Content-Type: text/x-csrc;
  charset="utf-8";
  name="test_aio_cancel.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="test_aio_cancel.c"

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/uio.h>
#include <fcntl.h>
#include <stdint.h>
#include <unistd.h>
#include <libaio.h>
#include <stdlib.h>
#include <stdio.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

const char usage[] = "Usage: test_aio [filename]";

int main(int argc, char *argv[])
{
	int res, i;
	struct timespec tspec;

	uint64_t data = 0xa5a5a5a5a5a5a5a5ULL;

	unsigned int iocbs_num = 1;

	struct iocb iocb_i[iocbs_num];
	struct iocb *iocbs[iocbs_num];
	struct io_event events[iocbs_num];
	io_context_t io_ctx;

	int fd;

	if (argc < 2) {
		fputs(usage, stderr);
		exit(1);
	}

	for (i = 0; i < iocbs_num; i++)
		iocbs[i] = &iocb_i[i];

	fd = open(argv[1], O_RDWR | O_SYNC);

	if (fd < 0) {
		perror("open");
		exit(1);
	}

	res = io_queue_init(iocbs_num, &io_ctx);

	if (res != 0) {
		fprintf(stderr, strerror(-res));
		exit(1);
	}

	int num_io = 1;

	io_prep_pread(iocbs[0], fd, &data, sizeof(data), 0);

	res = io_submit(io_ctx, num_io, iocbs);

	if (res != num_io) {
		fprintf(stderr, strerror(-res));
		exit(1);
	}

	res = io_cancel(io_ctx, iocbs[0], &events[0]);

	printf("io_cancel: res = %d\n", res);

	printf("events[0].res = %lu\n", events[0].res);
	printf("events[0].res2 = %lu\n", events[0].res2);

	tspec.tv_nsec = 0;
	tspec.tv_sec = 1;

	res = io_getevents(io_ctx, num_io, num_io, events, &tspec);

	printf("io_getevents: %d", res);

	io_queue_release(io_ctx);

	close(fd);
}

--Boundary-00=_APv/Lqw0Miwi0ny--
