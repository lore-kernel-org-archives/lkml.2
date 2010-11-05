Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0KEGjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 02:39:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58098 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0KEGjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 02:39:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ezgvC0D/krM9zi2OqNZakn1esw2bhBbLRPk7ft+pIQIRXVLcrftgJPycbVaov7NgXd
         RyUzZmtykpBTik3f6ey2yGZbxLFmMvuF+b2H7oBvpn+8+SGk8u2QWIAcVQi1ShgiS9Qw
         NmSmpK0Nm1OcJUHDWJLDDCT2JEtHwhLO9dzk4=
MIME-Version: 1.0
In-Reply-To: <AANLkTiknaHiWUzOH+MjAujk_+0JfX2x2auRCgFjUqhU-@mail.gmail.com>
References: <AANLkTikL4Ng0mJmeO0p_gtZWticd6NO3b9daHcRX4q1Q@mail.gmail.com>
	<AANLkTiknaHiWUzOH+MjAujk_+0JfX2x2auRCgFjUqhU-@mail.gmail.com>
Date: Fri, 5 Nov 2010 15:39:05 +0900
Message-ID: <AANLkTimtyAwuiG-yeKUVrviVB513vX9_q-2yjuo1mjTu@mail.gmail.com>
Subject: Re: mmotm 2010-11-03-12-17: memcg build fail
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg Thelen <gthelen@google.com>, Andrea Righi <arighi@develer.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 5, 2010 at 2:55 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Forgot cc lkml
>
> On Fri, Nov 5, 2010 at 1:54 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> Hi,
>>
>> Build failed without __divdi3 on i386, known issue?
>>
>> mm/built-in.o: In function `mem_cgroup_dirty_info':
>> /home/dave/vdb/build/mm/linux-2.6.36/mm/memcontrol.c:1251: undefined
>> reference to `__divdi3'
>> /home/dave/vdb/build/mm/linux-2.6.36/mm/memcontrol.c:1259: undefined
>> reference to `__divdi3'
>> make: *** [.tmp_vmlinux1] Error 1
>>

We should have used do_div.
Below patch solve the problem?

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 76386f4..8e6bb59 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1247,18 +1247,19 @@ bool mem_cgroup_dirty_info(unsigned long
sys_available_mem,
        if (dirty_param.dirty_bytes)
                info->dirty_thresh =
                        DIV_ROUND_UP(dirty_param.dirty_bytes, PAGE_SIZE);
-       else
-               info->dirty_thresh =
-                       (dirty_param.dirty_ratio * available_mem) / 100;
+       else {
+               info->dirty_thresh = dirty_param.dirty_ratio * available_mem;
+               do_div(info->dirty_thresh, 100);
+       }

        if (dirty_param.dirty_background_bytes)
                info->background_thresh =
                        DIV_ROUND_UP(dirty_param.dirty_background_bytes,
                                     PAGE_SIZE);
-       else
-               info->background_thresh =
-                       (dirty_param.dirty_background_ratio *
-                              available_mem) / 100;
+       else {
+               info->background_thresh =
dirty_param.dirty_background_ratio * available_mem;
+               do_div(info->background_thresh, 100);
+       }

        info->nr_reclaimable =
                mem_cgroup_page_stat(MEMCG_NR_RECLAIM_PAGES);

>> --
>> Regards
>> dave
>>
>
>
>
> --
> Regards
> dave
>



-- 
Kind regards,
Minchan Kim
