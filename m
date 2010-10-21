Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab0JUW6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:58:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63110 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab0JUW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z+lY37S8gprImRdNxS2OeCcqJUZe1Zf6CH99uvXmtmPwL3S9ADBYlqidM0+O5/bQeq
         cz0WJNLF2AeIdi9p8/xuw4mzvwF8DFgx/TP3uBlPdbnOVx4xZ7PWM+n6QyxN3PKb7Zv/
         iPS6Kem2VdniYr2T0s1YEoIHS1RUBYoBZqXb8=
Subject: Re: [PATCH] percpu_counter : add percpu_counter_add_fast()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20101021154333.f67fd870.akpm@linux-foundation.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-17-git-send-email-david@fromorbit.com>
	 <20100929215322.ff635d3e.akpm@linux-foundation.org>
	 <20100930061039.GX5665@dastard> <20101016075510.GH19147@amd>
	 <1287217748.2799.68.camel@edumazet-laptop>
	 <20101016020744.366bd9c6.akpm@linux-foundation.org>
	 <1287221475.2799.123.camel@edumazet-laptop>
	 <1287238754.2799.376.camel@edumazet-laptop>
	 <20101021154333.f67fd870.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 00:58:14 +0200
Message-ID: <1287701894.2607.32.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 21 octobre 2010 à 15:43 -0700, Andrew Morton a écrit :
> On Sat, 16 Oct 2010 16:19:14 +0200
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > The current way to change a percpu_counter is to call
> > percpu_counter_add(), which is a bit expensive.
> > (More than 40 instructions, possible false sharing, ...)
> 
> This is incorrect.  With my compiler it's 25 instructions except in the
> very rare case where a batch overflow occurs.
> 

Hmm

> And more than half of that is function call entry/exit overhead.
> 

gcc version 4.5.1

count : 5 instructions to call function

c10cfbb5:	a1 00 8f 53 c1       	mov    0xc1538f00,%eax
c10cfbba:	31 c9                	xor    %ecx,%ecx
c10cfbbc:	89 04 24             	mov    %eax,(%esp)
c10cfbbf:	ba 01 00 00 00       	mov    $0x1,%edx
c10cfbc4:	b8 c0 5b 50 c1       	mov    $0xc1505bc0,%eax
c10cfbc9:	e8 a2 64 0b 00       	call   c1186070 <__percpu_counter_add>

Then 39 instructions in hot path (no lock taken)

So its more than 40 as I stated 

c1186070 <__percpu_counter_add>:
c1186070:	55                   	push   %ebp
c1186071:	89 e5                	mov    %esp,%ebp
c1186073:	83 ec 1c             	sub    $0x1c,%esp
c1186076:	89 5d f4             	mov    %ebx,-0xc(%ebp)
c1186079:	89 75 f8             	mov    %esi,-0x8(%ebp)
c118607c:	89 7d fc             	mov    %edi,-0x4(%ebp)
c118607f:	89 c3                	mov    %eax,%ebx
c1186081:	8b 73 20             	mov    0x20(%ebx),%esi
c1186084:	64 a1 6c 10 59 c1    	mov    %fs:0xc159106c,%eax
c118608a:	8b 3c 85 a0 7d 53 c1 	mov    -0x3eac8260(,%eax,4),%edi
c1186091:	01 fe                	add    %edi,%esi
c1186093:	89 75 e8             	mov    %esi,-0x18(%ebp)
c1186096:	8b 06                	mov    (%esi),%eax
c1186098:	8b 75 08             	mov    0x8(%ebp),%esi
c118609b:	89 c7                	mov    %eax,%edi
c118609d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c11860a0:	c1 ff 1f             	sar    $0x1f,%edi
c11860a3:	01 55 ec             	add    %edx,-0x14(%ebp)
c11860a6:	89 7d f0             	mov    %edi,-0x10(%ebp)
c11860a9:	89 f7                	mov    %esi,%edi
c11860ab:	11 4d f0             	adc    %ecx,-0x10(%ebp)
c11860ae:	c1 ff 1f             	sar    $0x1f,%edi
c11860b1:	39 7d f0             	cmp    %edi,-0x10(%ebp)
c11860b4:	7f 3a                	jg     c11860f0 <__percpu_counter_add+0x80>
c11860b6:	7d 68                	jge    c1186120 <__percpu_counter_add+0xb0>
c11860b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
c11860bb:	f7 d9                	neg    %ecx
c11860bd:	89 ca                	mov    %ecx,%edx
c11860bf:	c1 fa 1f             	sar    $0x1f,%edx
c11860c2:	39 55 f0             	cmp    %edx,-0x10(%ebp)
c11860c5:	7e 19                	jle    c11860e0 <__percpu_counter_add+0x70>
c11860c7:	8b 7d ec             	mov    -0x14(%ebp),%edi
c11860ca:	8b 75 e8             	mov    -0x18(%ebp),%esi
c11860cd:	89 3e                	mov    %edi,(%esi)
c11860cf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c11860d2:	8b 75 f8             	mov    -0x8(%ebp),%esi
c11860d5:	8b 7d fc             	mov    -0x4(%ebp),%edi
c11860d8:	c9                   	leave  
c11860d9:	c3                   	ret    
c11860da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
c11860e0:	7c 0e                	jl     c11860f0 <__percpu_counter_add+0x80>
c11860e2:	39 4d ec             	cmp    %ecx,-0x14(%ebp)
c11860e5:	77 e0                	ja     c11860c7 <__percpu_counter_add+0x57>
c11860e7:	89 f6                	mov    %esi,%esi
c11860e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
c11860f0:	89 d8                	mov    %ebx,%eax
c11860f2:	e8 e9 41 1d 00       	call   c135a2e0 <_raw_spin_lock>
c11860f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c11860fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c11860fd:	01 43 10             	add    %eax,0x10(%ebx)
c1186100:	89 d8                	mov    %ebx,%eax
c1186102:	11 53 14             	adc    %edx,0x14(%ebx)
c1186105:	8b 55 e8             	mov    -0x18(%ebp),%edx
c1186108:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
c118610e:	e8 6d 41 1d 00       	call   c135a280 <_raw_spin_unlock>
c1186113:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c1186116:	8b 75 f8             	mov    -0x8(%ebp),%esi
c1186119:	8b 7d fc             	mov    -0x4(%ebp),%edi
c118611c:	c9                   	leave  
c118611d:	c3                   	ret    
c118611e:	66 90                	xchg   %ax,%ax
c1186120:	8b 7d 08             	mov    0x8(%ebp),%edi
c1186123:	39 7d ec             	cmp    %edi,-0x14(%ebp)
c1186126:	73 c8                	jae    c11860f0 <__percpu_counter_add+0x80>
c1186128:	8b 4d 08             	mov    0x8(%ebp),%ecx
c118612b:	f7 d9                	neg    %ecx
c118612d:	89 ca                	mov    %ecx,%edx
c118612f:	c1 fa 1f             	sar    $0x1f,%edx
c1186132:	39 55 f0             	cmp    %edx,-0x10(%ebp)
c1186135:	7f 90                	jg     c11860c7 <__percpu_counter_add+0x57>
c1186137:	eb a7                	jmp    c11860e0 <__percpu_counter_add+0x70>


