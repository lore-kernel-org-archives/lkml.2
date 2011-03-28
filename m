Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1C1OOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:14:44 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39209 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1C1OOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:organization:to:subject:date:user-agent:cc
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=v7uU4zxOX8wQV79+rKUZTYdwkShcMAET79LMJne5d2tQkVyRvTjao1NPSQMeyqjhyf
         cOzwDpoOwieWdWVoaECuval09lpKA9Y2VojEJrM+/XGzqQJSdWOq1KdW+F5dFDfeVMAv
         vi73FFZ6OG0/4HaBfvUIvfE+bed468btoniH4=
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
Organization: Nanjing University
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] ksm: take dirty bit as reference to avoid volatile pages
Date: Mon, 28 Mar 2011 22:14:18 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.38.1; KDE/4.5.5; i686; ; )
Cc: Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        "linux-mm" <linux-mm@kvack.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103282214.19345.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
