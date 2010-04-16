Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab0DPRCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 13:02:32 -0400
Received: from n1-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.153]:38118 "HELO
	n1-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758627Ab0DPRCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 13:02:30 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 217771.90611.bm@omp119.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type;
  b=dXLioQXFQXyluSzWX8dvUKwxn+DZqfdev8D8MqaMmdpYWHtXYLxT9NgEjgpscxx+Dwj6pRAQGh4ueNdl0mzieSPhINvAi0p+eqmZInJKhARD7RsiHnUMHAq5maVhR8BSRpQtwV+clGV0xWv5qi3waJ1pLMlmU9nPFyHjwgp7jAs=;
Message-ID: <136370.38015.qm@web114316.mail.gq1.yahoo.com>
X-YMail-OSG: LpSBxakVM1lDwQtxoUkxspSuRjZTF3Do4uFiuDc3mdB.a2M
 3gRcpBYi4yKRjlncM8dAkq9rSOkoscczLqCxNlCELxx.YGz2wigltYF7hyps
 123WUzG6r.xBaR2xNJ0GBPaYPhuahMIAmBRlgy2Z030YPAPVc.FuOlnZ2P_o
 60Mbr3opqpx3sPnuEeezwLt4Bn2fW.PnqaQl51C0Gzprou8cLjl4J18pUD0P
 TZTGSVpbASfqH.zFy7iF_jMAvea7queUbXWxyp1YFNIfh.e6HEB0CrLn1hp.
 5Icm3YcFw_z.kkXFi4g--
X-Mailer: YahooMailClassic/10.1.9 YahooMailWebService/0.8.100.260964
Date: Fri, 16 Apr 2010 10:02:30 -0700 (PDT)
From: Rick Sherm <rick.sherm@yahoo.com>
Subject: Trying to measure performance with splice/vmsplice ....
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to measure the perf gain by using splice.For now I'm trying to copy a 1G file using splice.(In real scenario, the driver will DMA the data to some buffer(which is mmap'd).The app will then write the newly-DMA'd data to the disk while some other thread is crunching the same buffer.The buffer is guaranteed to not be modified.To avoid copying I was thinking of : splice-IN-mmap'd-buffer->pipe and splice-OUT-pipe->file.)

PS - I've inlined some sloppy code that I cooked up.

Case1) read from input_file and write(O_DIRECT so no buff-cache is involved but it doesn't work) to dest_file.We can talk about the buff-cache later.

(csh#)time ./splice_to_splice

0.004u 1.451s 0:02.16 67.1%     0+0k 2097152+2097152io 0pf+0w

#define KILO_BYTE    (1024)
#define PIPE_SIZE    (64 * KILO_BYTE)
int filedes [2];


pipe (filedes);

fd_from = open(filename_from,O_RDWR|O_LARGEFILE|O_DIRECT),0777);
fd_to   = open(filename_to,(O_WRONLY|O_CREAT|O_LARGEFILE|O_DIRECT),0777);

to_write = 2048 * 512 * KILO_BYTE;

while (to_write) {
    ret = splice (fd_from, &from_offset, filedes [1], NULL, PIPE_SIZE,
                     SPLICE_F_MORE | SPLICE_F_MOVE);
    if (ret < 0) {
        printf("Error: LINE:%d ret:%d\n",__LINE__,ret);
            goto error;
    } else {
        ret = splice (filedes [0], NULL, fd_to,
                         &to_offset, PIPE_SIZE/*should be ret,but ...*/,
                         SPLICE_F_MORE | SPLICE_F_MOVE);
        if (ret < 0) {
            printf("Error: LINE:%d ret:%d\n",__LINE__);
                goto error;
        }
            to_write -= ret;
    }
}

Case 2) directly reading and writing:

Case2.1) copy 64K blocks

(csh#)time ./file_to_file 64
0.015u 1.066s 0:04.04 26.4%     0+0k 2097152+2097152io 0pf+0w

#define KILO_BYTE    (1024)
#define MEGA_BYTE    (1024 * (KILO_BYTE))
#define BUFF_SIZE    (64 * MEGA_BYTE)

posix_memalign((void**)&buff,4096,BUFF_SIZE);


fd_from = open(filename_from,(O_RDWR|O_LARGEFILE|O_DIRECT),0777);
fd_to   = open(filename_to,(O_WRONLY|O_CREAT|O_LARGEFILE|O_DIRECT),0777);
   

/* 1G file == 2048 * 512K blocks */
to_write = 2048 * 512 * KILO_BYTE;
copy_size = cmd_line_input * KILO_BYTE; /* control from cmd_line */
while (to_write) {
    ret = read(fd_from, buff,copy_size);
    if (ret != copy_size) {
        printf("Error: LINE:%d ret:%d\n",__LINE__,ret);
                goto error;
    } else {
        ret = write (fd_to,buff,copy_size);
        if (ret != copy_size) {
        printf("Error: LINE:%d ret:%d\n",__LINE__);
        goto error;
        }
            to_write -= ret;
    }
}

Case2.2) copy 512K blocks

(csh#)time ./file_to_file 512
0.004u 0.306s 0:01.86 16.1%     0+0k 2097152+2097152io 0pf+0w


Case 2.3) copy 1M blocks
time ./file_to_file 1024
0.000u 0.240s 0:01.88 12.7%     0+0k 2097152+2097152io 0pf+0w


Questions:
Q1) When using splice,why is the CPU consumption greater than read/write(case 2.1)?What does this mean?

Q2) How do I confirm that the memory bandwidth consumption does not spike up when using splice in this case? By this I mean, (node)cpu<->mem. The DMA-in/DMA-out will happen.You can't escape from that but the IOH-bus will be utilized. I want to keep the cpu(node)-mem path free(well, minimize unnecessary copies).

Q3) When using splice, even though the destination file is opened in O_DIRECT mode, the data gets cached. I verified it using vmstat.

r  b   swpd   free   buff    cache   
1  0      0 9358820 116576 2100904

./splice_to_splice

r  b   swpd   free   buff  cache
2  0      0 7228908 116576 4198164

I see the same caching issue even if I vmsplice buffers(simple malloc'd iov) to a pipe and then splice the pipe to a file. The speed is still an issue with vmsplice too.

Q4) Also, using splice, you can only transfer 64K worth of data(PIPE_BUFFERS*PAGE_SIZE) at a time,correct?.But using stock read/write, I can go upto 1MB buffer. After that I don't see any gain. But still the reduction in system/cpu time is significant.

I would appreciate any pointers.


thanks
Rick



      

