Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab1A0HmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 02:42:11 -0500
Received: from lo.gmane.org ([80.91.229.12]:46735 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab1A0HmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 02:42:10 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 0/6] use BUG_ON correctly
Date: Thu, 27 Jan 2011 07:41:58 +0000 (UTC)
Message-ID: <ihr7k5$qmm$5@dough.gmane.org>
References: <1296067193-15879-1-git-send-email-bosong.ly@taobao.com>
	<AANLkTikq2YttapeLKkSeM-MrPoBdvPR32-oL6BdBOKdf@mail.gmail.com>
	<4D410EF8.3070508@coly.li>
	<AANLkTi=NCoMNAnVrcs7D8xccK0928oG_W5Bp2sSVabWH@mail.gmail.com>
	<4D4112F1.70804@coly.li>
	<AANLkTikPtCL++c47vPCzqBh_veG+fzZWR2w2xAYDUgw=@mail.gmail.com>
	<4D411C69.8080503@coly.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 60.247.97.98
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 15:19:05 +0800, Coly Li wrote:
>>>>
>>> Could you please to identify a piece of kernel code which provides an
>>> example as the condition you mentioned ? So I can have a look firstly.
>>
>>     #   line  filename / context / line
>>     1     35  arch/mips/include/asm/bug.h<<HAVE_ARCH_BUG_ON>>
>>               #define HAVE_ARCH_BUG_ON
>>     2    115  arch/powerpc/include/asm/bug.h<<HAVE_ARCH_BUG_ON>>
>>               #define HAVE_ARCH_BUG_ON
> 
> I don't find arch dependent implementation of BUG_ON from the above
> files. Do I miss something ?

arch/mips/include/asm/bug.h:

static inline void  __BUG_ON(unsigned long condition)
{
        if (__builtin_constant_p(condition)) {
                if (condition)
                        BUG();
                else
                        return;
        }
        __asm__ __volatile__("tne $0, %0, %1"
                             : : "r" (condition), "i" (BRK_BUG));
}

#define BUG_ON(C) __BUG_ON((unsigned long)(C))

#define HAVE_ARCH_BUG_ON


arch/powerpc/include/asm/bug.h:

#define BUG_ON(x) do {                                          \
        if (__builtin_constant_p(x)) {                          \
                if (x)                                          \
                        BUG();                                  \
        } else {                                                \
                __asm__ __volatile__(                           \
                "1:     "PPC_TLNEI"     %4,0\n"                 \
                _EMIT_BUG_ENTRY                                 \
                : : "i" (__FILE__), "i" (__LINE__), "i" (0),    \
                  "i" (sizeof(struct bug_entry)),               \
                  "r" ((__force long)(x)));                     \
        }                                                       \
} while (0)

