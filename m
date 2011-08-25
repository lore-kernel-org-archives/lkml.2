Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1HYRml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:42:41 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37261 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1HYRmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:42:40 -0400
MIME-Version: 1.0
In-Reply-To: <0ad5d75e1d238d186a3beadefd9de80316409867.1314291910.git.jbaron@redhat.com>
References: <cover.1314291909.git.jbaron@redhat.com> <0ad5d75e1d238d186a3beadefd9de80316409867.1314291910.git.jbaron@redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 25 Aug 2011 19:42:19 +0200
X-Google-Sender-Auth: b1_-b05eqgRR30b20rc1zKh6guQ
Message-ID: <CAO+b5-q0dVQUVLgo3VosAjNWHYNCf=xv8_qcCjBfYuhVh9RT9Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] dynamic_debug: use a single printk() to emit msgs
To: Jason Baron <jbaron@redhat.com>
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 7:34 PM, Jason Baron <jbaron@redhat.com> wrote:
> -static int dynamic_emit_prefix(const struct _ddebug *descriptor)
> +#define PREFIX_SIZE 64
> +#define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0
> +
> +static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
>  {
> -       char tid[sizeof(int) + sizeof(int)/2 + 4];
> -       char lineno[sizeof(int) + sizeof(int)/2];
> +       int pos = 0;
>
> -       if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
> +       pos += snprintf(buf + pos, LEFT(pos), "%s", KERN_DEBUG);
> +       if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
>                if (in_interrupt())
> -                       snprintf(tid, sizeof(tid), "%s", "<intr> ");
> +                       pos += snprintf(buf + pos, LEFT(pos), "%s ",
> +                                               "<intr>");
>                else
> -                       snprintf(tid, sizeof(tid), "[%d] ",
> -                                task_pid_vnr(current));
> -       } else {
> -               tid[0] = 0;
> +                       pos += snprintf(buf + pos, LEFT(pos), "[%d] ",
> +                                               task_pid_vnr(current));
>        }
> +       if (desc->flags & _DPRINTK_FLAGS_INCL_MODNAME)
> +               pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->modname);
> +       if (desc->flags & _DPRINTK_FLAGS_INCL_FUNCNAME)
> +               pos += snprintf(buf + pos, LEFT(pos), "%s:", desc->function);
> +       if (desc->flags & _DPRINTK_FLAGS_INCL_LINENO)
> +               pos += snprintf(buf + pos, LEFT(pos), "%d ", desc->lineno);
>
> -       if (descriptor->flags & _DPRINTK_FLAGS_INCL_LINENO)
> -               snprintf(lineno, sizeof(lineno), "%d", descriptor->lineno);
> -       else
> -               lineno[0] = 0;
> -
> -       return printk(KERN_DEBUG "%s%s%s%s%s%s",
> -                     tid,
> -                     (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
> -                     descriptor->modname : "",
> -                     (descriptor->flags & _DPRINTK_FLAGS_INCL_MODNAME) ?
> -                     ":" : "",
> -                     (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
> -                     descriptor->function : "",
> -                     (descriptor->flags & _DPRINTK_FLAGS_INCL_FUNCNAME) ?
> -                     ":" : "",
> -                     lineno);
> +       return buf;
>  }

Shouldn't the new implementation guarantee that buf[] is
'\0'-terminated if pos >= PREFIX_SIZE ?

Bart.
