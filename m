Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab1FUM4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:56:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43185 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab1FUM4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:56:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=F5CDSkzqGN2Tcp8PdB3ZagIAcXCA+Pz4P2VxY6q6JxIgKjKZxqu9qmlsRfSzmBa1ET
         27LYsXnHhnYm91sr8U0E8c/qRuny2E/d1P/kD1QTuEAkGjkbzp1qFQ3M7neaouQ2/p7L
         Sh+kg+4tkptibU/olo65GWvh/uP4fbbtMmSYM=
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2 V2] ksm: take dirty bit as reference to avoid volatile pages scanning
Date: Tue, 21 Jun 2011 20:55:25 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.5.5; i686; ; )
Cc: Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, "linux-mm" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106212055.25400.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compared to the first version, this patch set addresses the problem of
dirty bit updating of virtual machines, by adding two mmu_notifier interfaces.
So it can now track the volatile working set inside KVM guest OS.

V1 log:
Currently, ksm uses page checksum to detect volatile pages. Izik Eidus 
suggested that we could use pte dirty bit to optimize. This patch series
adds this new logic.

Preliminary benchmarks show that the scan speed is improved by up to 16 
times on volatile transparent huge pages and up to 8 times on volatile 
regular pages.

Following is the test program to show this top speed up (you need to make 
ksmd takes about more than 90% of the cpu and watch the ksm/full_scans).

  #include <stdio.h>
  #include <stdlib.h>
  #include <errno.h>
  #include <string.h>
  #include <unistd.h>
  #include <sys/mman.h>
  
  #define MADV_MERGEABLE   12
  
  
  #define SIZE (2000*1024*1024)
  #define PAGE_SIZE 4096
  
  int main(int argc, char **argv)
  {
        unsigned char *p;
        int j;
        int ret;
  
          p = mmap(NULL, SIZE, PROT_WRITE|PROT_READ,
                   MAP_PRIVATE|MAP_ANONYMOUS, 0, 0);
        
        if (p == MAP_FAILED) {
                printf("mmap error\n");
                return 0;
        }
      
          ret = madvise(p, SIZE, MADV_MERGEABLE);
      
          if (ret==-1) {
                  printf("madvise failed \n");
                  return 0;
          }
  
        
        memset(p, 1, SIZE);
  
        while (1) {
                for (j=0; j<SIZE; j+=PAGE_SIZE) {
                        *((long*)(p+j+PAGE_SIZE-4)) = random();
                }
        }
  
        return 0;
  }
