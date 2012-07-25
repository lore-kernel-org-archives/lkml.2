Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab2GYSXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:23:07 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52167 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab2GYSXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:23:03 -0400
Date: Wed, 25 Jul 2012 12:36:11 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Marcel Selhorst <m.selhorst@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 2/3] TPM: Close data_pending and
 data_buffer races
Message-ID: <20120725173610.GA20351@linux.vnet.ibm.com>
References: <1323196162-2717-1-git-send-email-tim.gardner@canonical.com>
 <1323196162-2717-3-git-send-email-tim.gardner@canonical.com>
 <4EF0B9F8.9020305@linux.vnet.ibm.com>
 <4EF0E465.5060704@canonical.com>
 <4EF36C1F.6040409@linux.vnet.ibm.com>
 <4EF37A7A.2060504@canonical.com>
 <4EF38CBD.3080302@linux.vnet.ibm.com>
 <4EF48F64.4010509@canonical.com>
 <1325016165.2313.45.camel@falcor>
 <20120111194331.GB12299@hardened-box.br.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120111194331.GB12299@hardened-box.br.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072518-6078-0000-0000-00000D8A7A89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 11, 2012 at 05:43:31PM -0200, Rajiv Andrade wrote:
> On Tue, 27 Dec 2011, Mimi Zohar wrote:
> 
> > On Fri, 2011-12-23 at 07:25 -0700, Tim Gardner wrote:
> > > On 12/22/2011 01:02 PM, Rajiv Andrade wrote:
> > 
> > <snip>
> > 
> > > > It's inside the mutex region.
> > > >
> > > 
> > > Actually, the patch you sent (https://lkml.org/lkml/2011/12/22/257) is 
> > > _outside_ the mutex area, but I got your drift.
> > 
> > Yes, thanks for pointing it out in your original comments. I haven't
> > tested the following patch, but perhaps it will help clarify the updated
> > version, that I think Rajiv was describing ... 
> >
> 
> That's exactly it Mimi, thanks for writing down the patch.
> 
> > diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> > index 6a8771f..7dafd95 100644
> > --- a/drivers/char/tpm/tpm.c
> > +++ b/drivers/char/tpm/tpm.c
> > @@ -1210,7 +1210,6 @@ ssize_t tpm_read(struct file *file, char __user *buf,
> >  	del_singleshot_timer_sync(&chip->user_read_timer);
> >  	flush_work_sync(&chip->work);
> >  	ret_size = atomic_read(&chip->data_pending);
> > -	atomic_set(&chip->data_pending, 0);
> >  	if (ret_size > 0) {	/* relay data */
> >  		if (size < ret_size)
> >  			ret_size = size;
> > @@ -1221,8 +1220,10 @@ ssize_t tpm_read(struct file *file, char __user *buf,
> >  		if (rc)
> >  			ret_size = -EFAULT;
> > 
> > +		atomic_set(&chip->data_pending, 0);
> >  		mutex_unlock(&chip->buffer_mutex);
> > -	}
> > +	} else if (ret_size < 0)
> > +		atomic_set(&chip->data_pending, 0);
> > 
> >  	return ret_size;
> >  }
> 
> Tim, do you still see a race with the changes posted above?

After some testing, Mimi's patch works, but I don't believe there's any
reason to put the atomic_set() inside the lock of buffer_mutex. There's
no issue with the timer popping because del_singleshot_timer_sync()
ensures its not running before tpm_read proceeds.

WRT to zeroing the buffer though, it looks like there's a second
issue. The data buffer could be returned to the OS via kfree if release is
called before read. read can't be called after release is called, but at
that point the buffer is already returned to the OS. I'll update that
with a kzfree(), also in this patch:

Thanks,
Kent

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index e46e869..2901c3e 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -1163,7 +1163,7 @@ int tpm_release(struct inode *inode, struct file *file)
 	flush_work_sync(&chip->work);
 	file->private_data = NULL;
 	atomic_set(&chip->data_pending, 0);
-	kfree(chip->data_buffer);
+	kzfree(chip->data_buffer);
 	clear_bit(0, &chip->is_open);
 	put_device(chip->dev);
 	return 0;
@@ -1215,7 +1215,6 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 	del_singleshot_timer_sync(&chip->user_read_timer);
 	flush_work_sync(&chip->work);
 	ret_size = atomic_read(&chip->data_pending);
-	atomic_set(&chip->data_pending, 0);
 	if (ret_size > 0) {	/* relay data */
 		ssize_t orig_ret_size = ret_size;
 		if (size < ret_size)
@@ -1230,6 +1229,8 @@ ssize_t tpm_read(struct file *file, char __user *buf,
 		mutex_unlock(&chip->buffer_mutex);
 	}
 
+	atomic_set(&chip->data_pending, 0);
+
 	return ret_size;
 }
 EXPORT_SYMBOL_GPL(tpm_read);

