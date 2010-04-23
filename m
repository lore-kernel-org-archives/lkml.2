Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab0DWQHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:07:47 -0400
Received: from n2-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.154]:40687 "HELO
	n2-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757837Ab0DWQHo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:07:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 813112.48068.bm@omp122.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qELKocrHKAK9YQlPmY6I/6t3kYiLRRsM5GYwHH0cWv1O/UC/v8aupDgYfIP8PTU0rDnnpppyRPdEDTLaldoHsgmSWtFfrUDNWLDozPObRaFTA5KyJFQnjnPkH1izpH1Kj5mun9uCUxhin6V3BHQX68AMqvOA3C3WRXgPVj2OmSY=;
Message-ID: <723057.43066.qm@web114303.mail.gq1.yahoo.com>
X-YMail-OSG: Xa1KE88VM1krSZRgqKdNCFkR_ODfjK23bTzYCnK7x.5gP7e
 AU6mUq0DePjXLhFj1RfKJgQKA2REUwopnTJBVPjnETGTqMAXjV_JNFBVbsIO
 Apnk3h2ECOcs7ik2F4378NBXAOH6cUlS30lLFjkSOPehJSHJTU01ad07BWvg
 RkZ_oHRHl158Ui32QWAh4JUR.LlSF3tJsBONtjGs7oduqDC_4aEZYeAg3RbR
 OPTp3HqsyKxQU5UBO_xb.6F4ZUtqTZrZ94rXwejCJf8ttRlc_NJZYbQIbSoG
 dSc7VK_iJCiicGA--
X-Mailer: YahooMailClassic/10.1.9 YahooMailWebService/0.8.102.267879
Date: Fri, 23 Apr 2010 09:07:43 -0700 (PDT)
From: Rick Sherm <rick.sherm@yahoo.com>
Subject: Re: Trying to measure performance with splice/vmsplice ....
To: steve@digidescorp.com, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens - any assistance/pointers on 1) and 2) below 
will be great.I'm willing to test out any sample patch.

Steve,

--- On Wed, 4/21/10, Steven J. Magnani <steve@digidescorp.com> wrote:
> Hi Rick,
> 
> On Fri, 2010-04-16 at 10:02 -0700, Rick Sherm wrote:
> > Q3) When using splice, even though the destination
> file is opened in O_DIRECT mode, the data gets cached. I
> verified it using vmstat.
> > 
> > r b   swpd   free   buff cache   
> > 1 0     0 9358820 116576 2100904
> > 
> > ./splice_to_splice
> > 
> > r b swpd   free   buff cache
> > 2 0  0 7228908 116576  4198164
> > 
> > I see the same caching issue even if I vmsplice
> buffers(simple malloc'd iov) to a pipe and then splice the
> pipe to a file. The speed is still an issue with vmsplice
> too.
> > 
> 
> One thing is that O_DIRECT is a hint; not all filesystems
> bypass the cache. I'm pretty sure ext2 does, and I know fat doesn't. 
> 
> Another variable is whether (and how) your filesystem
> implements the splice_write file operation. The generic one (pipe_to_file)
> in fs/splice.c copies data to pagecache. The default one goes
> out to vfs_write() and might stand more of a chance of honoring
> O_DIRECT.
> 

True.I guess I should have looked harder. It's xfs and xfs's->file_ops points to 'generic_file_splice_read[write]'.Last time I had to 'fdatasync' and then fadvise to mimic 'O_DIRECT'.

> > Q4) Also, using splice, you can only transfer 64K
> worth of data(PIPE_BUFFERS*PAGE_SIZE) at a time,correct?.But
> using stock read/write, I can go upto 1MB buffer. After that
> I don't see any gain. But still the reduction in system/cpu
> time is significant.
> 
> I'm not a splicing expert but I did spend some time
> recently trying to
> improve FTP reception by splicing from a TCP socket to a
> file. I found that while splicing avoids copying packets to userland,
> that gain is more than offset by a large increase in calls into the
> storage stack.It's especially bad with TCP sockets because a typical
> packet has, say,1460 bytes of data. Since splicing works on PIPE_BUFFERS
> pages at a time, and packet pages are only about 35% utilized, each
> cycle to userland I could only move 23 KiB of data at most. Some
> similar effect may be in play in your case.
> 

Agreed,increasing number of calls will offset the benefit.
But what if:
1)We were to increase the PIPE_BUFFERS from '16' to '64' or 'some value'?
What are the implications in the other parts of the kernel?
2)There was a way to find out if the DMA-out/in from the initial buffer's that were passed are complete so that we are free to recycle them? Callback would be helpful.Obviously, the user-space-app will have to manage it's buffers but atleast we are guranteed that the buffers can be recycled(in other words no worrying about modifying in-flight data that is being DMA'd).

> Regards,
>  Steven J. Magnani           

regards
++Rick



      

