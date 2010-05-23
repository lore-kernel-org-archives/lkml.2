Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0EWQA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 12:00:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab0EWQAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 12:00:55 -0400
Date: Sun, 23 May 2010 18:56:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
	ring itself
Message-ID: <20100523155605.GB14733@redhat.com>
References: <20100505205814.GA7090@redhat.com> <4BF39C12.7090407@redhat.com> <201005201431.51142.rusty@rustcorp.com.au> <201005201438.17010.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005201438.17010.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 02:38:16PM +0930, Rusty Russell wrote:
> On Thu, 20 May 2010 02:31:50 pm Rusty Russell wrote:
> > On Wed, 19 May 2010 05:36:42 pm Avi Kivity wrote:
> > > > Note that this is a exclusive->shared->exclusive bounce only, too.
> > > >    
> > > 
> > > A bounce is a bounce.
> > 
> > I tried to measure this to show that you were wrong, but I was only able
> > to show that you're right.  How annoying.  Test code below.
> 
> This time for sure!

The share option does not work on some
boxes unless I apply the following:
essentially, this adds mb() after each write
and before read. It seems to make sense to
me: we must update our counter before we
wanit for another side.

diff --git a/cachebounce.c b/cachebounce.c
index 0387027..ebe5a37 100644
--- a/cachebounce.c
+++ b/cachebounce.c
@@ -77,6 +77,7 @@ int main(int argc, char *argv[])
 				count++;
 				counter->cacheline1 = count;
 				count++;
+				__sync_synchronize();
 			}
 			break;
 		case UNSHARE:
@@ -86,6 +87,7 @@ int main(int argc, char *argv[])
 				count++;
 				counter->cacheline2 = count;
 				count++;
+				__sync_synchronize();
 			}
 			break;
 		case LOCKSHARE:
@@ -98,6 +100,7 @@ int main(int argc, char *argv[])
 			break;
 		case LOCKUNSHARE:
 			while (count < MAX_BOUNCES) {
+				__sync_synchronize();
 				/* Spin waiting for other side to change it. */
 				while (counter->cacheline1 != count);
 				__sync_val_compare_and_swap(&counter->cacheline2, count, count+1);
@@ -115,6 +118,7 @@ int main(int argc, char *argv[])
 				count++;
 				counter->cacheline1 = count;
 				count++;
+				__sync_synchronize();
 			}
 			break;
 		case UNSHARE:
@@ -124,6 +128,7 @@ int main(int argc, char *argv[])
 				count++;
 				counter->cacheline1 = count;
 				count++;
+				__sync_synchronize();
 			}
 			break;
 		case LOCKSHARE:
