Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0FOCfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:35:08 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:46760 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044Ab0FOCfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:35:06 -0400
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: prevent kill(0, SIGTERM);
From: Ian Munsie <imunsie@au1.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
In-reply-to: <1276072680-17378-1-git-send-email-imunsie@au1.ibm.com>
References: <1276072680-17378-1-git-send-email-imunsie@au1.ibm.com>
Date: Tue, 15 Jun 2010 12:34:40 +1000
Message-Id: <1276568830-sup-3577@au1.ibm.com>
User-Agent: Sup/0.11
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Please consider merging this patch, it's a trivial fix to prevent perf
from killing too many processes in certain unusual situations - such as
killing the other intern's entire X session when called from eclipse
with a typo in the program being profiled.

Cheers,
-Ian

Excerpts from Ian Munsie's message of Wed Jun 09 18:38:00 +1000 2010:
> From: Ian Munsie <imunsie@au1.ibm.com>
> 
> At exit, perf record will kill the process it was profiling by sending a
> SIGTERM to child_pid (if it had been initialised), but in certain
> situations child_pid may be 0 and perf would mistakenly kill more
> processes than intended.
> 
> child_pid is set to the return of fork() to either 0 or the pid of the
> child. Ordinarily this would not present an issue as the child calls
> execvp to spawn the process to be profilled and would therefore never
> run it's sig_atexit and never attempt to kill pid 0.
> 
> However, if a nonexistant binary had been passed in to perf record the
> call to execvp would fail and child_pid would be left set to 0. The
> child would then exit and it's atexit handler, finding that child_pid
> was initialised to 0, would call kill(0, SIGTERM), resulting in every
> process within it's process group being killed.
> 
> In the case that perf was being run directly from the shell this
> typically would not be an issue as the shell isolates the process.
> However, if perf was being called from another program it could kill
> unexpected processes, which may even include X.
> 
> This patch changes the logic of the test for whether child_pid was
> initialised to only considder positive pids as valid, thereby never
> attempting to kill pid 0.
> 
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> ---
>  tools/perf/builtin-record.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 5e5c640..300da82 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -193,7 +193,7 @@ static void sig_handler(int sig)
>  
>  static void sig_atexit(void)
>  {
> -    if (child_pid != -1)
> +    if (child_pid > 0)
>          kill(child_pid, SIGTERM);
>  
>      if (signr == -1)
