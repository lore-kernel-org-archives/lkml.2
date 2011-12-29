Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1L2Aj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 19:39:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab1L2Aj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 19:39:27 -0500
Date: Wed, 28 Dec 2011 16:39:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Greg KH <gregkh@suse.de>, Brian Swetland <swetland@google.com>
Subject: Re: RFC: android logger feedback request
Message-Id: <20111228163925.6c37df26.akpm@linux-foundation.org>
In-Reply-To: <4EF264C3.6000104@am.sony.com>
References: <4EF264C3.6000104@am.sony.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 14:59:15 -0800
Tim Bird <tim.bird@am.sony.com> wrote:

> Hi all,
> 
> I'm looking for feedback on the Android logger code,

The code looks nice.

>
> ...
>
> +/* logger_offset - returns index 'n' into the log via (optimized) modulus */
> +#define logger_offset(n)	((n) & (log->size - 1))
> +

This macro depends upon the presence of a local variable called "log"
and is therefore all stinky.  Pass "log" in as an arg and convert it to
a regular C function.

>
> ...
>
> +/*
> + * get_entry_len - Grabs the length of the payload of the next entry starting
> + * from 'off'.
> + *
> + * Caller needs to hold log->mutex.
> + */
> +static __u32 get_entry_len(struct logger_log *log, size_t off)
> +{
> +	__u16 val;
> +
> +	switch (log->size - off) {
> +	case 1:
> +		memcpy(&val, log->buffer + off, 1);
> +		memcpy(((char *) &val) + 1, log->buffer, 1);

So numbers in the buffer are in host endian order.  That's worth
capturing in a comment somewhere.

There must be a way of doing the above more neatly, using
log->buffer[off] and log->buffer[0].  Perhaps using
include/linux/unaligned/packed_struct.h.

> +		break;
> +	default:
> +		memcpy(&val, log->buffer + off, 2);

get_unaligned()

> +	}
> +
> +	return sizeof(struct logger_entry) + val;
> +}
> +
>
> ...
>
> +static ssize_t logger_read(struct file *file, char __user *buf,
> +			   size_t count, loff_t *pos)
> +{
> +	struct logger_reader *reader = file->private_data;
> +	struct logger_log *log = reader->log;
> +	ssize_t ret;
> +	DEFINE_WAIT(wait);
> +
> +start:
> +	while (1) {
> +		prepare_to_wait(&log->wq, &wait, TASK_INTERRUPTIBLE);
> +
> +		mutex_lock(&log->mutex);

If mutex_lock() had to wait for the mutex, it will return in state
TASK_RUNNING, thus rubbing out the effects of prepare_to_wait().  We'll
just loop again so this is a benign buglet.

Could we lose a wakeup by running prepaer_to_wait() outside the lock? 
I don't think so, but I stopped thinking about it when I saw the above
bug.  These two lines should be switched around.

> +		ret = (log->w_off == reader->r_off);
> +		mutex_unlock(&log->mutex);
> +		if (!ret)
> +			break;
> +
> +		if (file->f_flags & O_NONBLOCK) {
> +			ret = -EAGAIN;
> +			break;
> +		}
> +
> +		if (signal_pending(current)) {
> +			ret = -EINTR;
> +			break;
> +		}
> +
> +		schedule();
> +	}
> +
> +	finish_wait(&log->wq, &wait);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&log->mutex);
> +
> +	/* is there still something to read or did we race? */
> +	if (unlikely(log->w_off == reader->r_off)) {
> +		mutex_unlock(&log->mutex);
> +		goto start;
> +	}
> +
> +	/* get the size of the next entry */
> +	ret = get_entry_len(log, reader->r_off);
> +	if (count < ret) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* get exactly one entry from the log */
> +	ret = do_read_log_to_user(log, reader, buf, ret);
> +
> +out:
> +	mutex_unlock(&log->mutex);
> +
> +	return ret;
> +}
> +
>
> ...
>
> +/*
> + * clock_interval - is a < c < b in mod-space? Put another way, does the line
> + * from a to b cross c?
> + */

This is where my little brain started to hurt.  I assume it's correct ;)

> +static inline int clock_interval(size_t a, size_t b, size_t c)
> +{
> +	if (b < a) {
> +		if (a < c || b >= c)
> +			return 1;
> +	} else {
> +		if (a < c && b >= c)
> +			return 1;
> +	}
> +
> +	return 0;
> +}

The explicit inline(s) are increaseingly old-fashioned.  gcc is good
about this now.

>
> ...
>
> +static ssize_t do_write_log_from_user(struct logger_log *log,
> +				      const void __user *buf, size_t count)
> +{
> +	size_t len;
> +
> +	len = min(count, log->size - log->w_off);
> +	if (len && copy_from_user(log->buffer + log->w_off, buf, len))
> +		return -EFAULT;
> +
> +	if (count != len)
> +		if (copy_from_user(log->buffer, buf + len, count - len))
> +			return -EFAULT;

Is it correct to simply return here without updating ->w_off? 
We've just copied "len" bytes in from userspace.

> +	log->w_off = logger_offset(log->w_off + count);
> +
> +	return count;
> +}
> +
> +/*
> + * logger_aio_write - our write method, implementing support for write(),
> + * writev(), and aio_write(). Writes are our fast path, and we try to optimize
> + * them above all else.
> + */
> +ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
> +			 unsigned long nr_segs, loff_t ppos)
> +{
> +	struct logger_log *log = file_get_log(iocb->ki_filp);
> +	size_t orig = log->w_off;
> +	struct logger_entry header;
> +	struct timespec now;
> +	ssize_t ret = 0;
> +
> +	now = current_kernel_time();
> +
> +	header.pid = current->tgid;
> +	header.tid = current->pid;

hm, I thought task_struct.pid was the pid.

Also, pids are not unique system-wide.  If the user is using PID
namespaces then the logs will contain what may be fatally confusing
duplicates.  This needs to be fixed, I expect.  

There are broader namespace issues which should be thought about.  Does
it make sense for readers in one container to be returned logs from a
different container?  Perhaps the do-it-via-a-filesystem proposals can
address this.

> +	header.sec = now.tv_sec;
> +	header.nsec = now.tv_nsec;
> +	header.len = min_t(size_t, iocb->ki_left, LOGGER_ENTRY_MAX_PAYLOAD);
> +
> +	/* null writes succeed, return zero */
> +	if (unlikely(!header.len))
> +		return 0;
> +
> +	mutex_lock(&log->mutex);
> +
> +	/*
> +	 * Fix up any readers, pulling them forward to the first readable
> +	 * entry after (what will be) the new write offset. We do this now
> +	 * because if we partially fail, we can end up with clobbered log
> +	 * entries that encroach on readable buffer.
> +	 */
> +	fix_up_readers(log, sizeof(struct logger_entry) + header.len);
> +
> +	do_write_log(log, &header, sizeof(struct logger_entry));
> +
> +	while (nr_segs-- > 0) {
> +		size_t len;
> +		ssize_t nr;
> +
> +		/* figure out how much of this vector we can keep */
> +		len = min_t(size_t, iov->iov_len, header.len - ret);
> +
> +		/* write out this segment's payload */
> +		nr = do_write_log_from_user(log, iov->iov_base, len);
> +		if (unlikely(nr < 0)) {
> +			log->w_off = orig;
> +			mutex_unlock(&log->mutex);
> +			return nr;
> +		}
> +
> +		iov++;
> +		ret += nr;
> +	}
> +
> +	mutex_unlock(&log->mutex);
> +
> +	/* wake up any blocked readers */
> +	wake_up_interruptible(&log->wq);
> +
> +	return ret;
> +}
> +
>
> ...
>
> +static int logger_release(struct inode *ignored, struct file *file)
> +{
> +	if (file->f_mode & FMODE_READ) {
> +		struct logger_reader *reader = file->private_data;
> +		list_del(&reader->list);

locking for reader->list?

> +		kfree(reader);
> +	}
> +
> +	return 0;
> +}
>
> ...
>
> +static long logger_ioctl(struct file *file, unsigned int cmd, unsigned long arg)

ew...

> +static struct logger_log *get_log_from_minor(int minor)
> +{
> +	if (log_main.misc.minor == minor)
> +		return &log_main;
> +	if (log_events.misc.minor == minor)
> +		return &log_events;
> +	if (log_radio.misc.minor == minor)
> +		return &log_radio;
> +	if (log_system.misc.minor == minor)
> +		return &log_system;
> +	return NULL;
> +}

ew...


