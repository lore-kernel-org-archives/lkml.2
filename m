Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0KDVhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 17:37:10 -0400
Received: from mail.openrapids.net ([64.15.138.104]:52555 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753154Ab0KDVhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 17:37:08 -0400
Date: Thu, 4 Nov 2010 17:37:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: masami.hiramatsu.pt@hitachi.com
Cc: linux-kernel@vger.kernel.org
Subject: tracing: concurrency aware strncpy
Message-ID: <20101104213705.GA17485@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:35:32 up 43 days,  1:37,  1 user,  load average: 0.04, 0.16,
	0.13
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,
This might help you out...

/*
 * ltt_relay_do_strncpy - copy a string up to a certain number of bytes
 * @dest: destination
 * @src: source
 * @len: max. length to copy
 * @terminated: output string ends with \0 (output)
 *
 * returns the number of bytes copied. Does not finalize with \0 if len is
 * reached.
 */
static __inline__
size_t ltt_relay_do_strncpy(void *dest, const void *src, size_t len,
                            int *terminated)
{
        size_t orig_len = len;

        *terminated = 0;
        /*
         * What we really want here is an __inline__ strncpy, but we
         * don't have constants, so gcc generally uses a function call.
         */
        for (; len > 0; len--) {
                *(u8 *)dest = ACCESS_ONCE(*(const u8 *)src);
                /* Check with dest, because src may be modified concurrently */
                if (*(const u8 *)dest == '\0') {
                        len--;
                        *terminated = 1;
                        break;
                }
                dest++;
                src++;
        }
        return orig_len - len;
}


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
