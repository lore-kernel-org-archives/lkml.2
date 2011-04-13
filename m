Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1DMOCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:02:13 -0400
Received: from nm16-vm0.bullet.mail.bf1.yahoo.com ([98.139.212.253]:43185 "HELO
	nm16-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756017Ab1DMOCL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:02:11 -0400
X-Greylist: delayed 371 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Apr 2011 10:02:11 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 221617.33173.bm@omp1037.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=j39C9ILpy2J8k2wPV0Q34YgWJOscLUVLFLcNayJIOx+JntsJE0iz4wRc4ln/Rxgkq7nu9xtsn84wb0Joh25+5HOoe7IsnSBbNgs8K+RQimSw1RjqmPFsMGmw5E/QP5crMVPWsPecbUsRzEvKXKFcV0epMPuSKslGfyfmXVS5iWw=;
Message-ID: <112566.51053.qm@web162019.mail.bf1.yahoo.com>
X-YMail-OSG: hjdX9awVM1m08Q8S.IKkzo9rJZEd7ONEmAl7QZLgu7eGWmk
 Au57tbNRUjXJzEt5Y_SgD5BFJPqUJwxrbsSpE3ycVb_GyMR.0nx5iveMhXEB
 DgVueqMwhNzpXEtVA7EBz6T2pjTFMLKG49oexVW03oCPPrdaSboaRA0GJnyo
 XG8M3Z_lKJ7O3r9.vlsfqAKRAQeLoSOQl1E80AZu1gClAa3N8z0rr6P1m3Qh
 ZGG3Mivv0VuTu.H.dikyTmC4TH.Q26LJADCuuiLjUoE9Y.I78FJSu4pb.O5T
 4SzD6or81mJmk88JIBmmxfP1pxr44FzJq3jAAq3ici6PJ4Otyuk8B4nAOL6e
 bKK4ozk8I_Nc5h2y1o4JyzoY_Wv2gH7QU55uj4kEjFUpwvG86aUMZ63FD
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.109.295617
Date: Wed, 13 Apr 2011 06:56:00 -0700 (PDT)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: Re: Regarding memory fragmentation using malloc....
To: =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Changli Gao <xiaosuo@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <BANLkTi=7KHMA_JOwQcMQj5M+XU=qO07s2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My requirement is, I wanted to measure memory fragmentation level in linux kernel2.6.29 (ARM cortex A8 without swap).
How can I measure fragmentation level(percentage) from /proc/buddyinfo ?

Example : After each page allocation operation, I need to measure fragmentation level. If the level is above 80%, I will trigger a OOM or something to the user.
How can I reproduce this memory fragmentation scenario using a sample program?

Here is my sample program: (to check page allocation using malloc)
----------------------------------------------
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include<unistd.h>


#define PAGE_SIZE       (4*1024)

#define MEM_BLOCK       (64*PAGE_SIZE)


#define MAX_LIMIT       (16)

int main()
{
        char *ptr[MAX_LIMIT+1] = {NULL,};
        int i = 0;

        printf("Requesting <%d> blocks of memory of block size <%d>........\n",MAX_LIMIT,MEM_BLOCK);
        system("cat /proc/buddyinfo");
        system("cat /proc/zoneinfo | grep free_pages");
        printf("*****************************************\n\n\n");
        for(i=0; i<MAX_LIMIT; i++)
        {
                ptr[i] = (char *)malloc(sizeof(char)*MEM_BLOCK);
                if(ptr[i] == NULL)
                {
                        printf("ERROR : malloc failed(counter %d) <%s>\n",i,strerror(errno));
                        system("cat /proc/buddyinfo");
                        system("cat /proc/zoneinfo | grep free_pages");
                        printf("press any key to terminate......");
                        getchar();
                        exit(0);
                }
                memset(ptr[i],1,MEM_BLOCK);
                sleep(1);
                //system("cat /proc/buddyinfo");
                //system("cat /proc/zoneinfo | grep free_pages");
                //printf("-----------------------------------------\n");
        }

        sleep(1);
        system("cat /proc/buddyinfo");
        system("cat /proc/zoneinfo | grep free_pages");
        printf("-----------------------------------------\n");

        printf("press any key to end......");
        getchar();

        for(i=0; i<MAX_LIMIT; i++)
        {
                if(ptr[i] != NULL)
                {
                        free(ptr[i]);
                }
        }

        printf("DONE !!!\n");

        return 0;
}
EACH BLOCK SIZE = 64 Pages ==> (64 * 4 * 1024)
TOTAL BLOCKS = 16
----------------------------------------------
In my linux2.6.29 ARM machine, the initial /proc/buddyinfo shows the following:
Node 0, zone      DMA     17     22      1      1      0      1      1      0      0      0      0      0
Node 1, zone      DMA     15    320    423    225     97     26      1      0      0      0      0      0

After running my sample program (with 16 iterations) the buddyinfo output is as follows:
Requesting <16> blocks of memory of block size <262144>........
Node 0, zone      DMA     17     22      1      1      0      1      1      0      0      0      0      0
Node 1, zone      DMA     15    301    419    224     96     27      1      0      0      0      0      0
    nr_free_pages 169
    nr_free_pages 6545
*****************************************


Node 0, zone      DMA     17     22      1      1      0      1      1      0      0      0      0      0
Node 1, zone      DMA     18      2    305    226     96     27      1      0      0      0      0      0
    nr_free_pages 169
    nr_free_pages 5514
-----------------------------------------

The requested block size is 64 pages (2^6) for each block. 
But if we see the output after 16 iterations the buddyinfo allocates pages only from Node 1 , (2^0, 2^1, 2^2, 2^3).
But the actual allocation should happen from (2^6) block in buddyinfo.

Questions:
1) How to analyse buddyinfo based on each page block size?
2) How and in what scenario the buddyinfo changes?
3) Can we rely completely on buddyinfo information for measuring the level of fragmentation?

Can somebody through some more lights on this???

Thanks,
Pintu

--- On Wed, 4/13/11, Américo Wang <xiyou.wangcong@gmail.com> wrote:

> From: Américo Wang <xiyou.wangcong@gmail.com>
> Subject: Re: Regarding memory fragmentation using malloc....
> To: "Pintu Agarwal" <pintu_agarwal@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Eric Dumazet" <eric.dumazet@gmail.com>, "Changli Gao" <xiaosuo@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>, "azurIt" <azurit@pobox.sk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
> Date: Wednesday, April 13, 2011, 6:44 AM
> On Wed, Apr 13, 2011 at 2:54 PM,
> Pintu Agarwal <pintu_agarwal@yahoo.com>
> wrote:
> > Dear All,
> >
> > I am trying to understand how memory fragmentation
> occurs in linux using many malloc calls.
> > I am trying to reproduce the page fragmentation
> problem in linux 2.6.29.x on a linux mobile(without Swap)
> using a small malloc(in loop) test program of BLOCK_SIZE
> (64*(4*K)).
> > And then monitoring the page changes in
> /proc/buddyinfo after each operation.
> > From the output I can see that the page values under
> buddyinfo keeps changing. But I am not able to relate these
> changes with my malloc BLOCK_SIZE.
> > I mean with my BLOCK_SIZE of (2^6 x 4K ==> 2^6
> PAGES) the 2^6 th block under /proc/buddyinfo should change.
> But this is not the actual behaviour.
> > Whatever is the blocksize, the buddyinfo changes only
> for 2^0 or 2^1 or 2^2 or 2^3.
> >
> > I am trying to measure the level of fragmentation
> after each page allocation.
> > Can somebody explain me in detail, how actually
> /proc/buddyinfo changes after each allocation and
> deallocation.
> >
> 
> What malloc() sees is virtual memory of the process, while
> buddyinfo
> shows physical memory pages.
> 
> When you malloc() 64K memory, the kernel may not allocate a
> 64K
> physical memory at one time
> for you.
> 
> Thanks.
> 


      
