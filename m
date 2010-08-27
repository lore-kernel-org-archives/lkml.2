Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab0H0OX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:23:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59004 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab0H0OXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 10:23:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [RFC PATCH 02/43] ptrace: cleanup ptrace_request()
Date: Fri, 27 Aug 2010 16:23:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com> <1282902149-12991-3-git-send-email-namhyung@gmail.com>
In-Reply-To: <1282902149-12991-3-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008271623.01761.arnd@arndb.de>
X-Provags-ID: V02:K0:qSH3nEBunoYJXL8FDYgfTFJg5305HXkyFrJnv8HPOPH
 cZyWOsZMEKyjPWOijnQtaX+Z20VydtFbY2Fqz/jbfY+LARq38g
 nIgnYBd/och+2gmVAEOimIig1apXxHR9Pybqav6bJdXmk3XmpY
 tL+uvTfdjtpP1VNm3fxl56Zon27O9uF0WQcqbausUriJo6/64p
 oPIB21B/ioF//TePMiCQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 August 2010, Namhyung Kim wrote:
> @@ -579,19 +580,19 @@ int ptrace_request(struct task_struct *child, long request,
>                 ret = ptrace_setoptions(child, data);
>                 break;
>         case PTRACE_GETEVENTMSG:
> -               ret = put_user(child->ptrace_message, (unsigned long __user *) data);
> +               ret = copy_to_user(datap, &child->ptrace_message,
> +                                  sizeof (child->ptrace_message)) ?
> +                       -EFAULT : 0;
>                 break;
>  
>         case PTRACE_GETSIGINFO:
>                 ret = ptrace_getsiginfo(child, &siginfo);
>                 if (!ret)
> -                       ret = copy_siginfo_to_user((siginfo_t __user *) data,
> -                                                  &siginfo);
> +                       ret = copy_siginfo_to_user(datap, &siginfo);
>                 break;

If you introduce two pointers, 'siginfo_t __user *usiginfo' and
'unsigned long __user *datap' instead of just 'datap', you can use
get_user/put_user everywhere, which would make the code better readable
and faster.

Otherwise this change looks good.

	Arnd
