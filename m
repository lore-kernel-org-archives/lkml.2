Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575Ab0JYT2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 15:28:04 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:40983 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341Ab0JYT2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 15:28:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19653.55831.692904.538148@quad.stoffel.home>
Date: Mon, 25 Oct 2010 15:27:19 -0400
From: "John Stoffel" <john@stoffel.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 06/11] IMA: use i_writecount rather than a private counter
In-Reply-To: <20101025184152.20504.94048.stgit@paris.rdu.redhat.com>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	<20101025184152.20504.94048.stgit@paris.rdu.redhat.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

Eric> IMA tracks the number of struct files which are holding a given
Eric> inode readonly and the number which are holding the inode write
Eric> or r/w.  It needs this information so when a new reader or
Eric> writer comes in it can tell if this new file will be able to
Eric> invalidate results it already made about existing files.

Eric> aka if a task is holding a struct file open RO, IMA measured the
Eric> file and recorded those measurements and then a task opens the
Eric> file RW IMA needs to note in the logs that the old measurement
Eric> may not be correct.  It's called a "Time of Measure Time of Use"
Eric> (ToMToU) issue.  The same is true is a RO file is opened to an
Eric> inode which has an open writer.  We cannot, with any validity,
Eric> measure the file in question since it could be changing.

So if ToMToU is blown away by opening a file RW, how do you handle a
denial of attack which just opens and closes a bunch of files under
IMA control as fast as it can?  

What happens then?  Does IMA try to re-calculate it's integrity
measurement each and every time this happens?  What does this do to
system performance?  

If I open a file RO, read 512 bytes in a random block, then writes
those same 512 bytes back to the exact same spot, what happens?  

While I'm really concerned about the overhead when it's disabled, I'm
not sure you've explained the overhead when it *IS* enabled, esp on
systems with lots of disks and lots of files.  

The problems with kernel.org is a perfect exmaple of how an annocuous
feature like this, can kill a system's performance.

John


Eric> This patch attempts to use the i_writecount field to track writers.  The
Eric> i_writecount field actually embeds more information in it's value than IMA
Eric> needs but it should work for our purposes and allow us to shrink the struct
Eric> inode even more.

Eric> Signed-off-by: Eric Paris <eparis@redhat.com>
Eric> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Eric> ---

Eric>  security/integrity/ima/ima.h      |    1 -
Eric>  security/integrity/ima/ima_iint.c |    6 ------
Eric>  security/integrity/ima/ima_main.c |   16 ++++++----------
Eric>  3 files changed, 6 insertions(+), 17 deletions(-)

Eric> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
Eric> index 80aca3d..b546b90 100644
Eric> --- a/security/integrity/ima/ima.h
Eric> +++ b/security/integrity/ima/ima.h
Eric> @@ -108,7 +108,6 @@ struct ima_iint_cache {
Eric>  	struct mutex mutex;	/* protects: version, flags, digest */
Eric>  	/* protected by inode->i_lock */
Eric>  	unsigned int readcount;	/* measured files readcount */
Eric> -	unsigned int writecount;/* measured files writecount */
Eric>  	struct kref refcount;	/* ima_iint_cache reference count */
Eric>  };
 
Eric> diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
Eric> index db71a13..e68891f 100644
Eric> --- a/security/integrity/ima/ima_iint.c
Eric> +++ b/security/integrity/ima/ima_iint.c
Eric> @@ -129,11 +129,6 @@ void iint_free(struct kref *kref)
iint-> readcount);
iint-> readcount = 0;
Eric>  	}
Eric> -	if (iint->writecount != 0) {
Eric> -		printk(KERN_INFO "%s: writecount: %u\n", __func__,
Eric> -		       iint->writecount);
Eric> -		iint->writecount = 0;
Eric> -	}
Eric>  	kref_init(&iint->refcount);
Eric>  	kmem_cache_free(iint_cache, iint);
Eric>  }
Eric> @@ -166,7 +161,6 @@ static void init_once(void *foo)
iint-> flags = 0UL;
Eric>  	mutex_init(&iint->mutex);
iint-> readcount = 0;
Eric> -	iint->writecount = 0;
Eric>  	kref_init(&iint->refcount);
Eric>  }
 
Eric> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
Eric> index 2f9b5d5..24660bf 100644
Eric> --- a/security/integrity/ima/ima_main.c
Eric> +++ b/security/integrity/ima/ima_main.c
Eric> @@ -94,8 +94,6 @@ static void ima_inc_counts(struct ima_iint_cache *iint, fmode_t mode)
 
Eric>  	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
iint-> readcount++;
Eric> -	if (mode & FMODE_WRITE)
Eric> -		iint->writecount++;
Eric>  }
 
Eric>  /*
Eric> @@ -173,18 +171,16 @@ static void ima_dec_counts(struct ima_iint_cache *iint, struct inode *inode,
iint-> readcount--;
Eric>  	}
Eric>  	if (mode & FMODE_WRITE) {
Eric> -		if (unlikely(iint->writecount == 0))
Eric> +		if (atomic_read(&inode->i_writecount) <= 0)
Eric>  			dump = true;
Eric> -		iint->writecount--;
Eric> -		if (iint->writecount == 0) {
Eric> -			if (iint->version != inode->i_version)
Eric> -				iint->flags &= ~IMA_MEASURED;
Eric> -		}
Eric> +		if (atomic_read(&inode->i_writecount) == 1 &&
Eric> +		    iint->version != inode->i_version)
Eric> +			iint->flags &= ~IMA_MEASURED;
Eric>  	}
 
Eric>  	if (dump && !ima_limit_imbalance(file)) {
Eric> -		printk(KERN_INFO "%s: open/free imbalance (r:%u w:%u)\n",
Eric> -		       __func__, iint->readcount, iint->writecount);
Eric> +		printk(KERN_INFO "%s: open/free imbalance (r:%u)\n",
Eric> +		       __func__, iint->readcount);
Eric>  		dump_stack();
Eric>  	}
Eric>  }

Eric> --
Eric> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Eric> the body of a message to majordomo@vger.kernel.org
Eric> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Eric> Please read the FAQ at  http://www.tux.org/lkml/

-- 
