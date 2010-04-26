Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0DZX25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:28:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49253 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab0DZX2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VvtkjvjIBqv2YRvK45MWn1jYpv9UWElrUi3FDmvE0qfHrqsttBbaPHERXxeKAuj+CV
         jusQAfZUFeEwvNDDIODfOOmp4CWDrKr3wRcy8HhZnG3vzMI0k6hSyhstAfXMYCHRQKT9
         CcUQeH5c6Npm6bwfr4VMSqy0uSme3WYgs6peE=
MIME-Version: 1.0
In-Reply-To: <1272321478-28481-2-git-send-email-mel@csn.ul.ie>
References: <1272321478-28481-1-git-send-email-mel@csn.ul.ie>
	 <1272321478-28481-2-git-send-email-mel@csn.ul.ie>
Date: Tue, 27 Apr 2010 08:28:52 +0900
Message-ID: <n2t28c262361004261628y1d6e53fbw505a78818c0d5228@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm,migration: During fork(), wait for migration to 
	end if migration PTE is encountered
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3QNT8mE005246

On Tue, Apr 27, 2010 at 7:37 AM, Mel Gorman <mel@csn.ul.ie> wrote:> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>>> At page migration, we replace pte with migration_entry, which has> similar format as swap_entry and replace it with real pfn at the> end of migration. But there is a race with fork()'s copy_page_range().>> Assume page migraion on CPU A and fork in CPU B. On CPU A, a page of> a process is under migration. On CPU B, a page's pte is under copy.>>        CPUA                    CPU B>                                do_fork()>                                copy_mm() (from process 1 to process2)>                                insert new vma to mmap_list (if inode/anon_vma)>        pte_lock(process1)>        unmap a page>        insert migration_entry>        pte_unlock(process1)>>        migrate page copy>                                copy_page_range>        remap new page by rmap_walk()>        pte_lock(process2)>        found no pte.>        pte_unlock(process2)>                                pte lock(process2)>                                pte lock(process1)>                                copy migration entry to process2>                                pte unlock(process1)>                                pte unlokc(process2)>        pte_lock(process1)>        replace migration entry>        to new page's pte.>        pte_unlock(process1)>> Then, some serialization is necessary. IIUC, this is very rare event but> it is reproducible if a lot of migration is happening a lot with the> following program running in parallel.>>    #include <stdio.h>>    #include <string.h>>    #include <stdlib.h>>    #include <sys/mman.h>>>    #define SIZE (24*1048576UL)>    #define CHILDREN 100>    int main()>    {>            int i = 0;>            pid_t pids[CHILDREN];>            char *buf = mmap(NULL, SIZE, PROT_READ|PROT_WRITE,>                            MAP_PRIVATE|MAP_ANONYMOUS,>                            0, 0);>            if (buf == MAP_FAILED) {>                    perror("mmap");>                    exit(-1);>            }>>            while (++i) {>                    int j = i % CHILDREN;>>                    if (j == 0) {>                            printf("Waiting on children\n");>                            for (j = 0; j < CHILDREN; j++) {>                                    memset(buf, i, SIZE);>                                    if (pids[j] != -1)>                                            waitpid(pids[j], NULL, 0);>                            }>                            j = 0;>                    }>>                    if ((pids[j] = fork()) == 0) {>                            memset(buf, i, SIZE);>                            exit(EXIT_SUCCESS);>                    }>            }>>            munmap(buf, SIZE);>    }>> copy_page_range() can wait for the end of migration.>> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>> Signed-off-by: Mel Gorman <mel@csn.ul.ie>Reviewed-by : Minchan Kim <minchan.kim@gmail.com>
-- Kind regards,Minchan Kim���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
